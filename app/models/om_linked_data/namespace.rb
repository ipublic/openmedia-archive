class OmLinkedData::Namespace
  require "addressable/uri"

  attr_reader :fqdn, :authority, :subdomain, :base_uri

  # Expects a URI with subdomain, e.g.; http://om.civicopenmedia.us
  def initialize(base_uri)
    @base_uri = base_uri.to_s
    addr = Addressable::URI.parse(@base_uri)
    @fqdn = addr.host
    @authority = escape_string(@fqdn)
    parts = addr.host.split('.')
    @subdomain = parts.first if parts.length == 3
    to_hash
  end

  def to_hash
    Hash[:base_uri => @base_uri,
         :fqdn => @fqdn,
         :authority => @authority,
         :subdomain => @subdomain]
  end
  
private
  def escape_string(str)
    str.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end
    
end