class OpenMedia::RawRecord < CouchRest::Model::Base
 
  use_database STAGING_DATABASE
  
  belongs_to :data_resource, :class_name=>'OpenMedia::DataResource'

  property :batch_serial_number
  property :published, Time
  timestamps!


  design do
    view :by_data_resource_id
    view :by_data_resource_id_and_published
    view :by_unpublished, 
            :map =>"function(doc) {
                      if (doc['model']=='OpenMedia::RawRecord' && doc['published']==null) {
                        emit(doc.data_resource_id, 1);
                      }
                    }"
  end
end
