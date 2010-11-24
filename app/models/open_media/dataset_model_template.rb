class OpenMedia::DatasetModelTemplate < CouchRest::Model::Base
  
  use_database STAGING_DATABASE
  
  property :import_id
  
  timestamps!

  validates_presence_of :import_id

  view_by :import_id
  
end
