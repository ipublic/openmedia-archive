require 'spec_helper'

describe LinkedData::ShapefileParser do

  before(:each) do
    @shapefile_name = File.join(FIXTURE_PATH, 'FireStnPt.zip')
    @shapefile_property_list = %w(OBJECTID_1 OBJECTID NAME GIS_ID SSL ADDRESS PHONE BFC 
                                  AMBULANCE RESCSQUAD MEDICUNIT TRUCK SPECIALTY DETAIL TYPE 
                                  ENGINE BATTALION RENSTATUS AID REL_UNITS WEB_URL geometry)

    @parser = LinkedData::ShapefileParser.new(@shapefile_name)
    @prop_list = @parser.properties
  end
  
  describe "class methods" do
    describe ".properties" do

      it "should not return an empty property list" do
        @prop_list.size.should == @shapefile_property_list.size
      end
      
      it "should return all property names as terms" do
        @prop_list.each {|p| @shapefile_property_list.include?(p.term).should == true }
      end
    end
  end
  
  describe "basics" do
  end
  
end