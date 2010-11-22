class OpenMedia::Organization < CouchRest::Model::Base

  use_database SITE_DATABASE
  unique_id :identifier 

  property :name
  property :identifier
  property :abbreviation
  property :email
  property :website_url
  property :phones, [OpenMedia::Phone]
  property :addresses, [OpenMedia::Address]
  collection_of :contacts, :class_name=>'OpenMedia::Contact'
  property :note
  
  # TODO: Add ability to upload agency logo 
  timestamps!

  ## Validations
  validates_presence_of :name
  
  ## Callbacks
  before_save :generate_identifier
  
  ## CouchDB Views
  # query with Organization.by_name
  view_by :name
  view_by :abbreviation
  view_by :name, :identifier
  
  def get_creator_content_documents
#    list = ContentDocument.by_creator_organization_id(:key => self['identifier']) # unless new?
=begin
  TODO ContentDocument model was removed.  Update this method
=end
    list = {}
  end

private
  def generate_identifier
    unless abbreviation.blank? 
      self['identifier'] = self.class.name.demodulize.downcase + '_' + abbreviation.rstrip.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    else
      self['identifier'] = self.class.name.demodulize.downcase + '_' + name.rstrip.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    end
  end
  
end

