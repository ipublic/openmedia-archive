require 'spec_helper'

describe LinkedData::CsvParser do

  before(:each) do
    @csv_filename = File.join(FIXTURE_PATH, 'crime_incidents_current.csv')
    @csv_property_list = ["NID", "CCN", "REPORTDATETIME", "SHIFT", "OFFENSE", "METHOD", 
                          "LASTMODIFIEDDATE", "BLOCKSITEADDRESS", "LATITUDE", "LONGITUDE", "CITY", "STATE", 
                          "WARD", "ANC", "SMD", "DISTRICT", "PSA", "NEIGHBORHOODCLUSTER", "HOTSPOT2006NAME", 
                          "HOTSPOT2005NAME", "HOTSPOT2004NAME", "BUSINESSIMPROVEMENTDISTRICT"]

    @parser = LinkedData::CsvParser.new(@csv_filename)
  end

  
  describe "class methods" do
    describe ".first_row" do
      before(:each) do
        @parser.header_row = true
        @row = @parser.first_row
      end
      
      it "should not return an empty row" do
        @row.length.should == @csv_property_list.length
      end
      
      it "should return header row with all property names" do
        @row.should == @csv_property_list
      end
    end

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
      
      it "should assign an expected_type to property" do
        @prop_list.first["expected_type"].should == RDF::XSD.integer.to_s
      end
    end

    describe ".records" do
      before(:each) do
        @parser.header_row = true
        @record_list = @parser.records
      end

      it "should read all rows from the source file" do
        @parser.record_count.should == 305
      end

      it "should return an array with correct number of records" do
        # this value should be one less than parsed_rows_count since first row is header
        @record_list.length.should == 304
      end

      it "should return an array of OpenMedia:RawRecord type" do
        @record_list.first.is_a?(OpenMedia::RawRecord).should == true
      end

      it "should import correct first and last CSV file values and types" do
        @record_list.first["CCN"].should == 11067390
        @record_list.last["CCN"].should == 11067384
      end
    end
  end
  
end