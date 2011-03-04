class OpenMedia::Catalog < CouchRest::Model::Base
  
  ## Catalogs can appear in any of these DBs: staging, public, community (as defined in Site::DATABASES). 
  ## This is the parent class, with StagingCatalog, PublicCatalog and CommunityCatalog children classes

  ## CouchDB database and record key
  use_database STAGING_DATABASE
  unique_id :identifier
  
  ## Properties
  property :title
  property :identifier

  validates :title, :presence=>true, :uniqueness => true
  validates_presence_of :metadata
  
  timestamps!
  
  ## Callbacks
  before_save :generate_identifier
  
  ## Views
  view_by :title
  view_by :title, :identifier
  view_by :dataset_id,
    :map =>
      "function(doc) {
         if ((doc['couchrest-type'] == 'OpenMedia::Catalog') && doc.dataset_ids!=null) {         
	   doc.dataset_ids.forEach(function(ds_id) { 
	     emit(ds_id, null); 
	   });        
         }
      }"
  

  def publisher_organization_name
    result = Organization.get(self.metadata['publisher_organization_id']).name
  end  

private
  
  def generate_identifier
    self['identifier'] = self.class.name.demodulize.downcase + '_' + title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end  
  
end
