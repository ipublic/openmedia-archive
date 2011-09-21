class LinkedData::RawRecord < CouchRest::Model::Base
 
  # use_database STAGING_DATABASE
  use_database VOCABULARIES_DATABASE
  
  # belongs_to :data_resource, :class_name=>'LinkedData::DataResource'

  property :batch_serial_number, String
  property :published, Time
  timestamps!


  design do
    view :by_batch_serial_number
    
  #   # view :by_data_resource_id
  #   # view :by_data_resource_id_and_published
    view :by_unpublished, 
            :map =>"function(doc) {
                      if (doc['model']=='LinkedData::RawRecord' && doc['published']==null) {
                        emit(doc.data_resource_id, 1);
                      }
                    }"
  end
  
  def published?
    self.published
  end
  
end
