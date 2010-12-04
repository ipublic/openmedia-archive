class OpenMedia::DatasetModelTemplate < CouchRest::Model::Base

  class_inheritable_accessor :dataset
  
  use_database STAGING_DATABASE
  
  property :import_id
  
  timestamps!

  validates_presence_of :import_id

  view_by :import_id

  def self.stored_design_doc(db = database)
    self.dataset
  end
  
  
end
