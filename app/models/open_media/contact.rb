class OpenMedia::Contact < CouchRest::Model::Base

  use_database SITE_DATABASE

  unique_id :email
  
  property :first_name, :default => ""
  property :last_name, :default => ""
  property :full_name
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
  view_by :full_name, :email
  
  def first_name=(str)
    self['first_name'] = str
    gen_full_name
  end

  def last_name=(str)
    self['last_name'] = str
    gen_full_name
  end

private  
  def gen_full_name
    self["full_name"] = self.first_name + ' ' + self.last_name
  end
end
