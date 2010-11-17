class OpenMedia::Contact < Hash
  include CouchRest::Model::CastedModel  

  property :first_name
  property :last_name
  property :job_title
  property :email
  property :website_url
  property :phones, [OpenMedia::Phone]
  property :addresses, [OpenMedia::Address]
  property :note


  validates_uniqueness_of :email
  
end
