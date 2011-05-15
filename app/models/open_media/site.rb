require 'open_media/no_site_defined'

class OpenMedia::Site < CouchRest::Model::Base

  DATABASES = [SITE_DATABASE.name, STAGING_DATABASE.name, TYPES_DATABASE.name, PUBLIC_DATABASE.name, COMMONS_DATABASE.name]

  use_database SITE_DATABASE
  
  ## Property Definitions
  # General properties
  property :identifier,  :read_only => true
  property :url
  property :default_dashboard
  property :welcome_message, :default => "Welcome to our Data Catalog"
  property :openmedia_name, :default => "Civic OpenMedia"
  property :terms_of_use, :default => "By using data made available through this site the user agrees to all the conditions stated in the following paragraphs: This agency makes no claims as to the completeness, accuracy or content of any data contained in this application; makes any representation of any kind, including, but not limited to, warranty of the accuracy or fitness for a particular use; nor are any such warranties to be implied or inferred with respect to the information or data furnished herein. The data is subject to change as modifications and updates are complete. It is understood that the information obtained from this site is being used at one's own risk. These Terms of Use govern any use of this service and may be changed at any time, without notice by the sponsor agency."
  property :adminstrator_contact_uri
  property :business_contact_uri
  
  # Administration properties
  property :internal_couchdb_server_uri, :default => "http://localhost:5984"
  property :public_couchdb_server_uri, :default => "http://localhost:5984"
  property :replicate_om_types, :default => true
  property :replicate_push_datasets, :default => true
  
  # Location properties
  property :municipality, OpenMedia::NamedPlace

  property :site_proxy_prefix
  property :site_canonical_url, :default => "http://localhost"
  property :site_default_city
  property :site_default_state
  
  # Services properties
  # Default googlemap_api_key is for http://localhost
  property :googlemap_api_key, :default => "ABQIAAAALBip6RF6CeNkMG5FsLJfjRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxRnUJ7zjI2v5FZxVYW7aoB2EAT8hQ"

  collection_of :datasources, :class_name=>'OpenMedia::Datasource'
  
  timestamps!

  ## Validations
  validates :identifier, :presence=>true, :uniqueness=>true
  validates_presence_of :municipality

  ## CouchDB Views
  view_by :identifier

  before_validate :set_url  

  def skos_collection
    collection = OpenMedia::Schema::SKOS::Collection.for("#{self.identifier}/concepts")
    unless collection.exists?
      collection.label = "SKOS Concept Collection for #{self.url} OpenMedia site"
      collection.save!
    end
    collection
  end

  def administrator_contact
    OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(self.adminstrator_contact_uri) if self.adminstrator_contact_uri
  end

  def business_contact
    OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(self.business_contact_uri) if self.business_contact_uri    
  end


  def metadata_repository
    db_name = "#{self.identifier}_metadata"
    unless Spira.repository(db_name)
      db = COUCHDB_SERVER.database!("#{db_name}")
      Spira.add_repository! db_name, RDF::CouchDB::Repository.new(:database=>db)
    end
    db_name    
  end

  def vcards_rdf_uri
    RDF::URI.new('http://data.civicopenmedia.org')/self.identifier/"vcards"
  end

  def initialize_metadata
    OpenMedia::Schema::VCard.configure_vcard(self)
    OpenMedia::Schema::Metadata.configure_metadata(self)
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
    if self.url.nil? && self.identifier
      self.url = "http://#{self.identifier}.#{OM_DOMAIN}#{OM_PORT == 80 ? '' : OM_PORT}"
    end
  end
end
