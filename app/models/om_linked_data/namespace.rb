class OmLinkedData::Namespace < Hash
  include CouchRest::Model::CastedModel
  require "addressable/uri"

  property :base_uri
  property :fqdn
  property :authority
  property :subdomain
  
  def initialize(b)
    super
    self["base_uri"] = b
    addr = Addressable::URI.parse(self["base_uri"])
    self["fqdn"] = addr.host
    self["authority"] = escape_string(self["fqdn"])
    parts = addr.host.split('.')
    self["subdomain"] = parts.first if parts.length == 3
    # return self
  end

private
  def escape_string(str)
    str.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end
    
end