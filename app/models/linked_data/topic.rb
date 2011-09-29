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
  property :qwerty, String, :read_only => true
  
  timestamps!

  validates_presence_of :term
  validates_presence_of :authority
  validates_presence_of :instance_database_name
  validates_presence_of :qwerty #, :message => "value: #{self.qwerty}"
  
  ## Callbacks
  before_create :generate_identifier
  before_create :create_instance_design_doc

  design do
    view :by_term
    view :by_label
  end

  # def qwerty=(val)
  #   write_attribute('qwerty', val)
  # end  
  # 
  # def qwerty
  #   self.qwerty
  # end  
  
  def instance_design_doc
    db = instance_database
    # db.get("_design/#{self.term}") unless self.term.nil?
    db.get(self.qwerty) unless self.term.nil?
  end  
  
  def all_instance_docs
    dsn = instance_design_doc
    dsn.view(:all)
  end
  
  # Use bulk_save to delete all data instances for this topic
  def destroy_instance_docs!
    docs = all_instance_docs
    docs.each {|doc| doc.destroy(true)}
    dsn.database.bulk_save
  end
  
  # Delete all data instance docs and design doc
  def destroy!
    destroy_instance_docs!
    destroy_design_doc!
  end
  
private
  def instance_database
    COUCHDB_SERVER.database(self.instance_database_name) unless self.instance_database_name.nil?
  end
  
  def create_instance_design_doc
    ddoc = CouchRest::Design.new(:language => "javascript",
                                  :views => {
                                    :all => {
                                      :map =>
                                        "function(doc) {if (doc['#{model_type_key}'] == '#{self.identifier}') {emit(doc['_id'],1);}}"
                                      }
                                    }
                                  )
    
    # At 1.1.2, CouchRest doesn't accept name and database attributes in constructor
    db = COUCHDB_SERVER.database(self.instance_database_name)
    ddoc.name = self.term
    # self.qwerty = ddoc.name
    ddoc.database = db
    ddoc.save!
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
    self.qwerty ||= "_design/#{self.term}"
    self.label ||= self.term
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.authority + '_' + 
                         escape_string(self.term.downcase) if new?
  end

  def escape_string(str)
    str.gsub(/[^A-Za-z0-9]/,'_').squeeze('_')
  end


end