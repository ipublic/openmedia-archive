require 'spec_helper'

describe OpenMedia::InferenceRules::Geocode do
  before(:all) do
    @street = "1600 Pennsylvania Ave NW"
    @city = "Washington"
    @state = "DC"
    @zipcode = "20502"
    @address = @street + ',' + @city + ' ' + @state + ' ' + @zipcode
    @usc_api_key = '3732a69450604bbc85a8d6773c4fb6d2'
  end
  
  describe 'with valid address' do
    it 'should return latitude & longitude from Geocoder.us geocode service' do
      @gc = OpenMedia::InferenceRules::Geocode.new
      @gc.address = @address
      @gc.geocode_geocoder_us

      @gc.latitude.to_i.should == 38
      @gc.longitude.to_i.should == -77
    end
    
    it 'should return latitude & longitude from USC geocode service' do
      # Note - USC service requires an API key
      @gc = OpenMedia::InferenceRules::Geocode.new(:usc_api_key => @usc_api_key,
                                                    :street => @street, 
                                                    :city => @city, 
                                                    :state => @state, 
                                                    :zipcode => @zipcode)
      @gc.geocode_usc
      @gc.latitude.to_i.should == 38
      @gc.longitude.to_i.should == -77
    end

    it 'should provide a GeoJSON point object' do
      @gc = OpenMedia::InferenceRules::Geocode.new(:usc_api_key => @usc_api_key,
                                                    :street => @street, 
                                                    :city => @city, 
                                                    :state => @state, 
                                                    :zipcode => @zipcode)
      @gc.geocode_usc
      @pt = @gc.to_geojson
      @pt["type"].should == "Point"
      @pt["coordinates"][0].to_i.should == -77
      @pt["coordinates"][1].to_i.should == 38
    end
  end
end

