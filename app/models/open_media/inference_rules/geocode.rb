class OpenMedia::InferenceRules::Geocode < OpenMedia::InferenceRules::InferenceRule
  # require 'addressable/uri'
  # require 'addressable/template'
  require 'rest_client'

  # Free requests throttled to 1 every 15 seconds
  # Non-profit or commercial: Paypal $50 per 20,000 records, with a $50 minimum, to payment@geocoder.us
  # For best results please use a comma between the street and the city, and add the zip code
  GEOCODER_US_SERVICE = "http://rpc.geocoder.us/service/csv"
  
  # After 2500 transactions, must sign up as partner or pay for service
  # https://webgis.usc.edu/Services/Default.aspx
  USC_GEOCODE_SERVICE = 'https://webgis.usc.edu/Services/Geocode/WebService/GeocoderWebServiceHttpNonParsed_V02_95.aspx'
  
  attr_accessor :address, :street, :city, :state, :zipcode, :usc_version, :usc_api_key
  attr_reader :latitude, :longitude, :elevation
  
  def initialize(options={})
    @usc_version = options.has_key?(:usc_version) ? options[:usc_version] : 2.95
    @usc_api_key = options[:usc_api_key] if options.has_key?(:usc_api_key)
    @address = options[:address] if options.has_key?(:address)
    @street = options[:street] if options.has_key?(:street)
    @city = options[:city] if options.has_key?(:city)
    @state = options[:state] if options.has_key?(:state)
    @zipcode = options[:zipcode] if options.has_key?(:zipcode)
  end
    
  def geocode_geocoder_us
    if !@address.nil?
      response = get GEOCODER_US_SERVICE, {:params => {:address => @address}}
    else
      response = get GEOCODER_US_SERVICE, {:params => {:address => merge_address}}
    end

    if response.length > 5
      @latitude = response[0]
      @longitude = response[1]
#      "Lat: #{@latitude}, Lon: #{longitude}"
   end
   response
  end
  
  def geocode_usc
    raise ArgumentError, "USC geocode service requires an usc_api_key" if @usc_api_key.nil?
    response = get USC_GEOCODE_SERVICE, {:params => {
                                          :apiKey => @usc_api_key,
                                          :version => @usc_version,
                                          :streetAddress => @street,
                                          :city => @city,
                                          :state => @state
                                          }}
                                                                  
    if response.length > 12
      @latitude = response[3]
      @longitude = response[4]
    end
    response
  end
  
  def to_geojson
    GeoJson::Point.new(GeoJson::Position.new(@longitude.to_f, @latitude.to_f)) unless @longitude.nil? or @latitude.nil?
  end
  
  def to_triples
    
  end
    
private
  def get(uri, headers={})
    begin
      RestClient.get(uri, headers).to_s.split(',')
    rescue Exception => e
      raise e
    end
  end

  def merge_address
    address_str << "#{street}" unless @street.blank?
    address_str << " #{city}" unless @city.blank?
    address_str << " #{state}" unless @state.blank?
    address_str << " #{zipcode}" unless @zipcode.blank?
    address_str = address_str.strip
  end

end