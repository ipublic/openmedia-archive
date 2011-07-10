class Schemas::VCard::Name < Hash
  include CouchRest::Model::CastedModel    

  # based on vcard properties
  property :first_name, String    # :alias => "given-name"
  property :middle_name, String   # :alias => "additional-name"
  property :last_name, String     # :alias => :family-name
  property :prefix, String        # :alias => "honorific-prefix"
  property :suffix, String        # :alias => "honorific-suffix"

end