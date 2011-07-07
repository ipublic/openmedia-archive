class OpenMedia::Email < Hash
  include CouchRest::Model::CastedModel    

  # based on vcard properties
  property :type   # Home, Work
  property :value

end