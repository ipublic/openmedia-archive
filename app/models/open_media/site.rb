require 'open_media/no_site_defined'

class OpenMedia::Site < CouchRest::Model::Base
  
  DATABASES = [SITE_DATABASE.name, STAGING_DATABASE.name, TYPES_DATABASE.name, PUBLIC_DATABASE.name, COMMONS_DATABASE.name]

  use_database SITE_DATABASE
  
  ## Property Definitions
  # General properties
  property :identifier,  :read_only => true
  property :url
  property :openmedia_name, :default => "Civic OpenMedia"
  belongs_to :adminstrator_contact_id, :class_name=>'OpenMedia::Contact'
  belongs_to :business_contact_id, :class_name=>'OpenMedia::Contact'
  
  # Administration properties
  property :internal_couchdb_server_uri, :default => "http://localhost:5984"
  property :public_couchdb_server_uri, :default => "http://localhost:5984"
  property :replicate_community_catalog
  
  # Location properties
  property :gnis, OpenMedia::Gnis # e.g.; 584282 for Ellicott City, MD
  
  property :site_domain_name, :default => "example.gov"
  property :site_proxy_prefix
  property :site_canonical_url, :default => "http://localhost"
  property :site_organization_id
  property :site_default_city
  property :site_default_state
  
  # Services properties
  # Default googlemap_api_key is for http://localhost
  property :googlemap_api_key, :default => "ABQIAAAALBip6RF6CeNkMG5FsLJfjRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxRnUJ7zjI2v5FZxVYW7aoB2EAT8hQ"
  
  timestamps!

  ## Validations
  validates_presence_of :url, :identifier

  ## CouchDB Views
  # singleton class - no views
  
  def self.instance
    @instance ||= self.first
    if @instance.nil?
      raise OpenMedia::NoSiteDefined.new
    else
      @instance
    end
  end

  def url=(url)
    self['url'] = url
    generate_identifier
  end

  def domains
    OpenMedia::Schema::Domain.by_site_id(:startkey=>self.id, :endkey=>"#{self.id}\u9999")
  end

private
  def generate_identifier
    if !url.blank?
      self.url =~ /^https?:\/\/(.*)$/
      self['identifier'] = $1.gsub(/^\-|\-$/,'').gsub(/\./,'')
    end
  end
  

end
