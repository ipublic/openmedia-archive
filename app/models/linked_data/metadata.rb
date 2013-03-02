class LinkedData::Metadata < Hash
  include CouchRest::Model::Embeddable
  
  # property :creator
  # property :publisher 
  # property :title 
  property :language, :default => 'en-US'
  property :conforms_to 
  property :description
  property :resourcetype, :default => "RDF::DCTYPE.Dataset"

end