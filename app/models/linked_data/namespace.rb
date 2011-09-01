class LinkedData::Namespace

  attr_reader :base_uri, :authority, :domain, :subdomain

  def initialize(openmedia_url)
    parts = openmedia_url.to_s.split('.')
    @subdomain = parts.first.split("http://").last
    @domain = openmedia_url.to_s.split(subdomain + '.').last

    # authority => "civicopenmedia_us_dcgov"
    @authority = domain.gsub('.','_') + '_' + subdomain
    @base_uri = "http://#{@domain}/#{@subdomain}"
    Hash[:base_uri => @base_uri, :authority => @authority, :domain => @domain, :subdomain => @subdomain]
  end

end
