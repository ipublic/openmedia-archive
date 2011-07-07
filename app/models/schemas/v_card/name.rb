class Schemas::VCard::Name < Hash
  include CouchRest::Model::CastedModel    

  # based on vcard properties
  property :full_name, String     # :alias => :fn
  property :first_name, String    # :alias => "given-name"
  property :middle_name, String   # :alias => "additional-name"
  property :last_name, String     # :alias => :family-name
  property :nickname, String      # :alias => :nickname
  property :prefix, String        # :alias => "honorific-prefix"
  property :suffix, String        # :alias => "honorific-suffix"
  property :job_title, String     # :alias => "Title"

end