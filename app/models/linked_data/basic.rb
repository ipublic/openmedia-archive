class LinkedData::Basic < CouchRest::Model::Base
  property :serial_number
  property :data_source_id
  timestamps!

  design do
    view :by_serial_number
    view :by_data_source_id
  end

end
