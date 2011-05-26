class Schema::Namespace < Hash
  include CouchRest::Model::CastedModel
  
  property :alias, String            # alias => "foaf"
  property :iri_base, String         # iri_base => "http://xmlns.com/foaf/0.1/"
  
end