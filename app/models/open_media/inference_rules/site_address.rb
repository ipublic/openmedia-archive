class OpenMedia::InferenceRules::SiteAddress < OpenMedia::InferenceRules::InferenceRule

  require 'rest_client'
  RestClient.log = '/tmp/om_rest_client.log'

  # Obtain a Geonames account for free or fee web services
  # Sign up for account at http://www.geonames.org/
  # Go to http://www.geonames.org/manageaccount and click link to enable free web service access
  GEONAMES_USERNAME = 'ipublic'

  # Geonames API: http://www.geonames.org/export/ws-overview.html
  GEONAMES_REVERSE_GEOCODE_ADDRESS = "http://api.geonames.org/findNearestAddressJSON"
  GEONAMES_REVERSE_GEOCODE_INTERSECTION = "http://api.geonames.org/findNearestIntersectionJSON"
  GEONAMES_REVERSE_GEOCODE_STREETS = "http://api.geonames.org/findNearbyStreetsJSON"

  def reverse_geocode_address(lat, long)
    response = ws_get(GEONAMES_REVERSE_GEOCODE_ADDRESS, {:params => {:lat => lat,
                                                         :lng => long,
                                                         :username => GEONAMES_USERNAME }})
  end

  def reverse_geocode_intersection(lat, long)
    response = ws_get(GEONAMES_REVERSE_GEOCODE_INTERSECTION, {:params => {:lat => lat,
                                                              :lng => long,
                                                              :username => GEONAMES_USERNAME }})
  end

  def reverse_geocode_streets(lat, long)
    response = ws_get(GEONAMES_REVERSE_GEOCODE_STREETS, {:params => {:lat => lat,
                                                         :lng => long,
                                                         :username => GEONAMES_USERNAME }})
  end

  def ws_get(uri, headers={})
    begin
      RestClient.get(uri, headers).to_s.split(',')
    rescue Exception => e
      raise e
    end
  end

end