class OpenMedia::InferenceRules::GeographicName < OpenMedia::InferenceRules::InferenceRule

  require 'rest_client'
  require 'json'
  RestClient.log = '/tmp/om_rest_client.log'

  # Obtain a Geonames account for free or fee web services
  # Sign up for account at http://www.geonames.org/
  # Go to http://www.geonames.org/manageaccount and click link to enable free web service access
  GEONAMES_USERNAME = 'ipublic'

  # Geonames API: http://www.geonames.org/export/ws-overview.html
  GEONAMES_PLACE_NAME = "http://api.geonames.org/searchJSON"
  GEONAMES_PLACE_NAME_BY_ZIPCODE = "http://api.geonames.org/postalCodeLookupJSON"

  GNIS_SERVICE = "http://gisdata.usgs.gov//XMLWebServices2/TNM_Gazetteer_Service.asmx/searchName"


  def self.find_by_name(municipality, state_abbrev=nil)
    response = ws_get(GEONAMES_PLACE_NAME, {:params => {:q => municipality,
                                                     :isNameRequired => true,
                                                     :country => 'us',
                                                     :adminCode1 => state_abbrev,
                                                     :featureClass => 'A',
                                                     :username => GEONAMES_USERNAME }})
    geoname_places = response["geonames"]
    named_places = []
    geoname_places.each { |place| named_places << named_place_map(place) }
    named_places
  end

  def self.find_by_name_and_id(municipality, source_id)
    self.find_by_name(municipality).detect{|np| np.source_id==source_id}
  end


  def self.find_by_zipcode (zipcode)
    # js callback option available
    response = ws_get(GEONAMES_PLACE_NAME_BY_ZIPCODE, {:params => {:postalcode => zipcode,
                                                               :country => "us",
                                                               :featureClass => 'A',
                                                               :username => GEONAMES_USERNAME }})
                                                               
    geoname_places = response["postalcodes"]
    named_places = []
    geoname_places.each { |place| named_places << named_place_map(place) }
    named_places
  end

  def self.gnis_place_name(place_name)
    # GNIS is free service, however the only filters are PlaceName and PlaceType
    # Multiple results are returned in flat XML without any IDs
    response = ws_get(GNIS_SERVICE, {:params => {:PlaceName => place_name,
                                             :PlaceType => 'Civil',
                                             :inNumRecords => '20',
                                             :inFirstRecord => '1'}})                            
  end
  
  def self.named_place_map(geoname_hash)
    np = OpenMedia::NamedPlace.new
    # Geonames returns different keys for name, depending on web service call
    np.name = geoname_hash["placeName"]                if geoname_hash.has_key? "placeName"
    np.name = geoname_hash["name"]                     if geoname_hash.has_key? "name"
    
    np.state_abbreviation = geoname_hash["adminCode1"] if geoname_hash.has_key? "adminCode1"
    np.source_id = geoname_hash["geonameId"]           if geoname_hash.has_key? "geonameId"
    np.source = "http://geonames.org"

    pt = GeoJson::Point.new(GeoJson::Position.new(geoname_hash["lng"].to_f, 
                                                  geoname_hash["lat"].to_f)) if geoname_hash.has_key? "lng" and
                                                                                geoname_hash.has_key? "lat"

    np.geometries << pt unless pt.nil?
    np
  end
  
  def self.ws_get(uri, headers={})
    begin
      res = RestClient.get(uri, headers)
      JSON.parse res.body if res.headers[:content_type].include? "application/json"
      
    rescue Exception => e
      raise e
    end
  end
  
end
