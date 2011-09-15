require 'spec_helper'

describe LinkedData::CsvParser do

  before(:each) do
    @csv_filename = File.join(FIXTURE_PATH, 'crime_incidents_current.csv')
    @csv_property_list = ["NID", "CCN", "REPORTDATETIME", "SHIFT", "OFFENSE", "METHOD", "LASTMODIFIEDDATE",
      "BLOCKSITEADDRESS", "LATITUDE", "LONGITUDE", "CITY", "STATE", "WARD", "ANC", "SMD", "DISTRICT", "PSA",
      "NEIGHBORHOODCLUSTER", "HOTSPOT2006NAME", "HOTSPOT2005NAME", "HOTSPOT2004NAME", "BUSINESSIMPROVEMENTDISTRICT"]

    @property_constants = {:batch_serial_number => "bsn-123ABC", :data_resource_id => "dr-123ABC"}
    @parser = LinkedData::CsvParser.new(@csv_filename, {:property_constants => @property_constants})
  end

  
  describe "class methods" do
    describe ".properties" do
      before(:each) do
        @parser.header_row = true
        @prop_list = @parser.properties
      end
      
      it "should not return an empty property list" do
        @prop_list.length.should == @csv_property_list.length
      end
      
      it "should return all property names as terms" do
        @prop_list.each {|p| @csv_property_list.include?(p.term).should == true }
      end
    end

    describe ".parse" do
      before(:each) do
        @record_list = @parser.parse
      end

      it "should not return an empty array of records" do
        @record_list.size.should > 0
      end

      it "should return an array of OpenMedia:RawRecord type" do
        @record_list.first.is_a?(OpenMedia::RawRecord).should == true
      end

      it "should append property constants to each OpenMedia:RawRecord" do
        @property_constants.each {|k,v| @record_list.first[k].should == v}
      end
    end
  end
  
  describe "basics" do
  end
  
end