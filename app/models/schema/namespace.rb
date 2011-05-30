class Schema::Namespace < CouchRest::Model::Base
  require "addressable/uri"

  use_database TYPES_DATABASE
  unique_id :identifier

  property :identifier
  property :uri
  property :authority
  property :abbreviation, String            # alias => "abbreviation"
  
  validates_uniqueness_of :identifier, :view => 'all'
  
  before_create :generate_identifier
  
  view_by :abbreviation
  view_by :authority
  
  def uri=(value)
    if value.is_a?(Hash)
      self["uri"] = value 
    else
      addressable_uri = Addressable::URI.parse(value)
      self["authority"] = addressable_uri.authority
      self["uri"] = addressable_uri.to_hash
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
                         self.abbreviation if new?
  end
  
  def escape_string(str)
    str.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end
    
end