require 'spec_helper'

describe LinkedData::UrlParser do

  before(:each) do
    @web_service = "http://api.geonames.org/searchJSON"
    @user_name = 'ipublic'
    @municipality = 'Anchorage'
    @state_abbbreviation = 'AK'
    @parameters = {:q => @municipality, :adminCode1 => @state_abbbreviation, :featureClass => 'A', 
                    :isNameRequired => true, :country => 'us', :style => 'full', :maxRows => 12, 
                    :username => @user_name }
                    
    @property_list = ["totalResultsCount", "geonames"]
                          
    @parser = LinkedData::UrlParser.new(@web_service, {:parameters => @parameters})
  end

  
  describe "class methods" do
    describe ".properties" do
      before(:each) do
        @props = @parser.properties
      end
      
      it "should not return an empty property list" do
        @props.length.should == @property_list.length
      end
      
      it "should return all property names as terms" do
        @props.each {|p| @property_list.include?(p.term).should == true }
      end
      
      it "should assign an expected_type to property" do
        @props.first["expected_type"].should == RDF::XSD.integer.to_s
      end
    end

    describe ".records" do
      before(:each) do
        @record_list = @parser.records
      end

      it "should return an array with correct number of records" do
        @record_list.length.should == 2
      end

      it "should return an array of OpenMedia:RawRecord type" do
        @record_list.first.is_a?(LinkedData::RawRecord).should == true
      end

      it "should return correct values" do
        @record_list.last["geonames"].first["adminCode2"].should == "020"
      end
    end
  end
  
end