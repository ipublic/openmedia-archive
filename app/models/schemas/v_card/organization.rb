class Schemas::VCard::Organization < Hash
  include CouchRest::Model::CastedModel    

  # based on vcard properties
  property :name        # :alias => organization-name
  property :department  # :alias => organization-unit

end