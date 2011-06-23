class OmLinkedData::Namespace
  
  attr_reader :base_uri, :authority, :domain, :subdomain
  
  def initialize(openmedia_url)
    parts = openmedia_url.split('.')
    @subdomain = parts.first.split("http://").last
    @domain = openmedia_url.split(subdomain + '.').last

    # authority => "civicopenmedia_us_dcgov"
    @authority = domain.gsub('.','_') + '_' + subdomain
    @base_uri = "http://#{@domain}/#{@subdomain}"
  end

private
  def escape_string(str)
    str.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end
  
end
