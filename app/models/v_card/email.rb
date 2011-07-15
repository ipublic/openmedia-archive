class VCard::Email < Hash
  include CouchRest::Model::CastedModel    

  EMAIL_TYPES = %w(Home Work)

  # based on vcard properties
  property :type   # Home, Work
  property :value

end