require 'open_media/no_site_defined'

class OpenMedia::Site < CouchRest::Model::Base

  DATABASES = [SITE_DATABASE.name, STAGING_DATABASE.name, VOCABULARIES_DATABASE.name, COMMONS_DATABASE.name]

  use_database SITE_DATABASE
  
  ## Property Definitions
  # General properties
  
  belongs_to :administrator_contact, :class_name => "VCard::VCard"
  belongs_to :business_contact, :class_name => "VCard::VCard"
  
  property :identifier #, :read_only => true
  property :url
  property :base_uri
  property :authority
  property :default_dashboard
  property :welcome_banner, :default => "Welcome to our Data Catalog"
  property :welcome_message, :default => "Your resource for government open data"
  property :openmedia_name, :default => "Civic OpenMedia"
  property :terms_of_use, :default => "By using data made available through this site the user agrees to all the conditions stated in the following paragraphs: This agency makes no claims as to the completeness, accuracy or content of any data contained in this application; makes any representation of any kind, including, but not limited to, warranty of the accuracy or fitness for a particular use; nor are any such warranties to be implied or inferred with respect to the information or data furnished herein. The data is subject to change as modifications and updates are complete. It is understood that the information obtained from this site is being used at one's own risk. These Terms of Use govern any use of this service and may be changed at any time, without notice by the sponsor agency."
  
  # Administration properties
  property :private_couchhost, :default => "http://localhost:5984"
  property :public_couchhost, :default => "http://localhost:5984"
  property :replicate_om_types, TrueClass, :default => true
  property :replicate_push_datasets, TrueClass, :default => true
  
  # Location properties
  property :municipality, OpenMedia::NamedPlace

  property :site_proxy_prefix
  # property :site_canonical_url, :default => "http://localhost"
  # property :site_default_city
  # property :site_default_state
  
  # Services properties
  # Default googlemap_api_key is for http://localhost
  property :googlemap_api_key, :default => "ABQIAAAALBip6RF6CeNkMG5FsLJfjRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxRnUJ7zjI2v5FZxVYW7aoB2EAT8hQ"

  collection_of :datasources, :class_name=>'OpenMedia::Datasource'
  
  timestamps!

  # Validations
  validates_presence_of :identifier
  validates_presence_of :municipality
  validates_uniqueness_of :identifier, :view => 'all'

  before_create :set_url

  ## CouchDB Views
  view_by :identifier
  view_by :authority


  def skos_collection
    collection = OpenMedia::Schema::SKOS::Collection.for("#{self.identifier}/concepts")
    unless collection.exists?
      collection.label = "SKOS Concept Collection for #{self.url} OpenMedia site"
      collection.save!
    end
    collection
  end

  def metadata_repository
    # db_name = "#{self.identifier}_metadata"
    # unless Spira.repository(db_name)
    #   db = COUCHDB_SERVER.database!("#{db_name}")
    #   Spira.add_repository! db_name, RDF::CouchDB::Repository.new(:database=>db)
    # end
    # db_name    
  end

  def initialize_metadata
    # OpenMedia::Schema::VCard.configure_vcard(self)
    # OpenMedia::Schema::Metadata.configure_metadata(self)
  end
  
  def geomarker
    Cartographer::Gmarker.new(:name=> "Site", :marker_type => "Building", :position => ll)  
  end    

  def ll 
    @ll = Array.[]( 39.2722118, -76.83419 ) # default to Ellicott City, MD
    
    # Find geoemtry point value and reverse coordinates the way Google likes it
    self.municipality.geometries.each {|g| @ll = g.coordinates.reverse if g.type == "Point"}
    @ll
  end

private
  def set_url
    self.url = "http://#{self.identifier}.#{OM_DOMAIN}#{OM_PORT == 80 ? '' : OM_PORT}"
    ns = ::LinkedData::Namespace.new(self.url)
    self.authority = ns.authority
    self.base_uri = ns.base_uri
  end
end