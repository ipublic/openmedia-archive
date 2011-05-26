class Schema::Collection < CouchRest::Model::Base
  
  property :namespace, Schema::Namespace

  property :label, String       # User assigned name, RDFS#Label
  property :tags, [String]

  timestamps!

end