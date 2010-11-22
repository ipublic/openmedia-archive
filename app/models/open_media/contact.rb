class OpenMedia::Contact < CouchRest::Model::Base

  use_database SITE_DATABASE

  unique_id :email
  
  property :first_name
  property :last_name
  property :job_title
  property :email
  property :website_url
  property :phones, [OpenMedia::Phone]
  property :addresses, [OpenMedia::Address]
  property :note

  timestamps!

  view_by :last_name, :first_name
  view_by :first_name, :last_name
  view_by :organization_name
  view_by :name, :email
  
  
end
