class Schema::Namespace < CouchRest::Model::Base
  require "addressable/uri"

  use_database TYPES_DATABASE
  unique_id :identifier

  property :identifier
  property :uri                     # addressable/uri hash values
  property :authority
  property :authority_uri
  property :abbreviation, String    # used for CURIE abbreviations
  
  validates_uniqueness_of :identifier, :view => 'all'
  
  before_create :generate_identifier
  
  view_by :authority_uri
  
  def uri=(value)
    if value.is_a?(Hash)
      # Record came from database
      self["uri"] = value 
    else
      add_uri = Addressable::URI.parse(value)
      self["authority"] = add_uri.authority
      self["authority_uri"] = escape_string(self["authority"])
      self["uri"] = add_uri.to_hash
    end
  end
  
  def abbreviation=(value)
    self["abbreviation"] = escape_string(value)
  end
  
  def prefix 
    self["abbreviation"] + ":"
  end
  
private
  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.authority_uri if new?
  end
  
  def escape_string(str)
    str.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end
    
end