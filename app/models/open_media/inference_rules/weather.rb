class OpenMedia::InferenceRules::Weather < OpenMedia::InferenceRules::InferenceRule

  require 'rest_client'
  RestClient.log = '/tmp/om_rest_client.log'

  GEONAMES_USERNAME = 'ipublic'
  GEONAMES_NEAREST_WEATHER_STATION = "http://api.geonames.org/findNearByWeatherJSON"
  GEONAMES_CURRENT_WEATHER = "http://api.geonames.org/weatherIcaoJSON"

  def nearest_station(lat, long)
    response = get(GEONAMES_NEAREST_WEATHER_STATION, {:params => 
                                                      {:lat => lat,
                                                       :lng => long,
                                                       :username => GEONAMES_USERNAME }})
  end
  
  def current_conditions(icao_code)
    # ICAO - International Civil Avaition Organization code, e,g, KBWI = Baltimore International Airport
    # Results are reported in following units
    #   Elevation = meters
    #   Wind speed = Knots
    #   Temperature = Celsius
    
    response = get(GEONAMES_CURRENT_WEATHER, {:params => 
                                                    {:ICAO => icao_code,
                                                     :username => GEONAMES_USERNAME }})
  end
  
private
  def get(uri, headers={})
    begin
      RestClient.get(uri, headers).to_s.split(',')
    rescue Exception => e
      raise e
    end
  end
  
  
end