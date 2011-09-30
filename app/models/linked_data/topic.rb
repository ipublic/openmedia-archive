class LinkedData::Topic < CouchRest::Model::Base

  use_database VOCABULARIES_DATABASE
  unique_id :identifier

  belongs_to :vocabulary, :class_name => "LinkedData::Vocabulary"
  belongs_to :creator, :class_name => "VCard::VCard"
  belongs_to :publisher, :class_name => "VCard::VCard"

  property :identifier, String, :read_only => true
  property :term, String
  property :label, String
  property :authority, String
  property :description, String
  
  property :instance_database_name, String
  property :instance_class_name, String, :read_only => true
  property :instance_design_doc_id, String, :read_only => true
  
  timestamps!

  validates_presence_of :term
  validates_presence_of :authority
  validates_presence_of :instance_database_name
  
  ## Callbacks
  before_create :generate_identifier
  before_create :create_instance_design_doc

  design do
    view :by_term
    view :by_label
  end
  
  def instance_database
    COUCHDB_SERVER.database(self.instance_database_name) unless self.instance_database_name.nil?
  end
  
  def instance_design_doc
    db = instance_database
    db.get(self.instance_design_doc_id) # unless self.instance_design_doc_id.nil?
  end
  
  # Create a dynamic CouchRest::Model::Base class for this Topic
  def couchrest_model
    return if self.term.nil? || instance_database.nil?
    
    if Object.const_defined?(self.instance_class_name)
      klass = Object.const_get(self.instance_class_name)
    else
      db = instance_database
      prop_list = self.vocabulary.properties.inject([]) {|memo, p| memo << p.term}
      self.vocabulary.properties.each {|p| prop_list << p.term} unless self.vocabulary.nil?
      klass = Object.const_set(self.instance_class_name.intern, 
        Class.new(CouchRest::Model::Base) do
          use_database db
          prop_list.each {|prop_name| property prop_name.to_sym}
          timestamps!
        end
        )
    end
    klass
  end
  
  # Provide a CouchRest::Document instance for this Topic
  def new_instance_doc(options={})
   couchrest_model.new(options) unless couchrest_model.nil?
  end
  
  def instance_view(view_name)
    instance_design_doc.view(view_name.to_sym)
  end
  
  # Use bulk_save to delete all data instances for this topic
  def destroy_instance_docs!
    docs = couchrest_model.all
    destroy_count = docs.count
    docs.each {|doc| doc.destroy}

    # docs.each {|doc| doc.destroy(true)}
    # instance_database.bulk_save

    destroy_count
  end
  
  # Delete all data instance docs and design doc
  def destroy!
    destroy_instance_docs!
    destroy_instance_design_doc!
  end
  
private
  def create_instance_design_doc
    write_attribute(:instance_class_name, self.term.singularize.camelize)
    write_attribute(:instance_design_doc_id, "_design/#{self.instance_class_name}")

    ddoc = CouchRest::Document.new(:_id => self.instance_design_doc_id,
                                 :language => "javascript",
                                  :views => {
                                    :all => {
                                      :map =>
                                        "function(doc) {
                                           if (doc['#{model_type_key}'] == '#{self.instance_class_name}') 
                                             {emit(doc['_id'],1);}}"
                                      }
                                    }
                                  )
    
    db = instance_database
    res = db.save_doc(ddoc)
  end

  def spatial_view
    {:spatial => {
      :full => "function(doc) {if (doc.geometry) {emit(doc.geometry, {id: doc._id, geometry: doc.geometry}); }}",
      :minimum => "function(doc) {if (doc.geometry) {emit(doc.geometry, 1); }}"
      }
    }
  end
  
  def destroy_instance_design_doc!
    instance_design_doc.destroy
  end

  def generate_identifier
    self.label ||= self.term
    id = self.class.to_s.split("::").last.downcase + '_' +
                         self.authority + '_' + 
                         escape_string(self.term.downcase) if new?
    write_attribute(:identifier, id)
  end

  def escape_string(str)
    str.gsub(/[^A-Za-z0-9]/,'_').squeeze('_')
  end

end
