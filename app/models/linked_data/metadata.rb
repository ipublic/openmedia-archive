class LinkedData::Metadata < Hash
  include CouchRest::Model::CastedModel
  
  property :creator   # =>OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(creator_uri)
  property :publisher # =>OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(publisher_uri)
  property :language, :default => 'en-US'
  property :conforms_to # =>rdfs_class
  property :title       # =>rdfs_class.label
  property :description # =>rdfs_class.comment
  property :resourcetype, :default => "RDF::DCTYPE.Dataset"

end