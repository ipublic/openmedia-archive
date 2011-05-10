class OpenMedia::RawRecord < CouchRest::Model::Base
 
  use_database STAGING_DATABASE
  
  property :datasource_id
  property :batch_serial_number
  property :published, Time
  timestamps!

  belongs_to :datasource, :class_name=>'OpenMedia::Datasource'
  
  view_by :datasource_id
end
