class OmLinkedData::Type < CouchRest::Model::Base
  
  use_database TYPES_DATABASE

  property :uri, String
  property :label, String
  property :primitive, TrueClass, :default => false
  collection_of :properties
  
  view_by :uri
  view_by :label

end
