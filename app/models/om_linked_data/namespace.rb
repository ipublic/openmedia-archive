class OmLinkedData::Namespace < Hash
  require "addressable/uri"
  include CouchRest::Model::CastedModel
  
  property :uri
  property :fqdn
  property :subdomain
  property :authority
  
  # Expects a URI with subdomain, e.g.; http://om.civicopenmedia.us
  def initialize(uri)
    self.uri = uri

    addr = Addressable::URI.parse(self.uri)
    self.fqdn = addr.host
    self.authority = escape_string(self.fqdn)
    parts = addr.host.split('.')
    self.subdomain = parts.first if parts.length == 3
  end
  
private
  def escape_string(str)
    str.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end
    
end