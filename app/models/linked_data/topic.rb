class LinkedData::Topic < CouchRest::Model::Base

  use_database VOCABULARIES_DATABASE
  unique_id :identifier

  belongs_to :vocabulary, :class_name => "LinkedData::Vocabulary"
  belongs_to :creator, :class_name => "VCard::VCard"
  belongs_to :publisher, :class_name => "VCard::VCard"

  property :identifier, String
  property :term, String
  property :label, String
  property :authority, String
  property :description, String
  property :instance_database_name, String
  property :instance_design_doc_id, String, :read_only => true
  
  
  # property :qwerty, String, :read_only => true
  
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
    view :by_instance_design_doc_id
  end

  def instance_database
    COUCHDB_SERVER.database(self.instance_database_name) unless self.instance_database_name.nil?
  end
  
  def instance_design_doc
    db = instance_database
    db.get(self.instance_design_doc_id) # unless self.instance_design_doc_id.nil?
  end  
  
  def instance_all_docs
    dsn = instance_design_doc
    dsn.view(:all)
  end
  
  # Use bulk_save to delete all data instances for this topic
  def destroy_instance_docs!
    docs = instance_all_docs
    docs.each {|doc| doc.destroy(true)}
    dsn.database.bulk_save
  end
  
  # Delete all data instance docs and design doc
  def destroy!
    destroy_instance_docs!
    destroy_design_doc!
  end
  
private
  def create_instance_design_doc
    write_attribute(:instance_design_doc_id, "_design/#{self.term}")
    ddoc = CouchRest::Document.new(:_id => self.instance_design_doc_id,
                                 :language => "javascript",
                                  :views => {
                                    :all => {
                                      :map =>
                                        "function(doc) {if (doc['#{model_type_key}'] == '#{self.identifier}') {emit(doc['_id'],1);}}"
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
  
  def destroy_design_doc!
    self.design_doc.destroy
  end

  def generate_identifier
    self.label ||= self.term
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.authority + '_' + 
                         escape_string(self.term.downcase) if new?
  end

  def escape_string(str)
    str.gsub(/[^A-Za-z0-9]/,'_').squeeze('_')
  end


end