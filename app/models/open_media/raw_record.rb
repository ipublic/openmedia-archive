class OpenMedia::RawRecord < CouchRest::Model::Base
 
  use_database STAGING_DATABASE
  
  property :datasource_id
  property :batch_serial_number
  property :published, Time
  timestamps!

  belongs_to :datasource, :class_name=>'OpenMedia::Datasource'
  
  view_by :datasource_id
  view_by :datasource_id, :published
  view_by :unpublished, :map =>"function(doc) {
                                  if (doc['couchrest-type']=='OpenMedia::RawRecord' && doc['published']==null) {
                                    emit(doc.datasource_id, 1);
                                  }
                                }"
end
