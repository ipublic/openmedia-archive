class OmLinkedData::Datatype < CouchRest::Model::Base
  
  use_database TYPES_DATABASE

  property :uri
  property :label
  
  view_by :uri
  view_by :label

end