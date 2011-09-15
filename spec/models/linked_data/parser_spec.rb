require 'spec_helper'

describe LinkedData::Parser do

  before(:each) do
    @parser = LinkedData::Parser.new
  end
  
  describe "class methods" do
    describe ".type_from_data_value" do
      it "should identify integer types" do
        @parser.type_from_data_value(0).should == RDF::XSD.integer.to_s
        @parser.type_from_data_value(-0).should == RDF::XSD.integer.to_s
        @parser.type_from_data_value(12345).should == RDF::XSD.integer.to_s
        @parser.type_from_data_value(-12345).should == RDF::XSD.integer.to_s
        @parser.type_from_data_value("12,345").should == RDF::XSD.integer.to_s
        @parser.type_from_data_value("-12,345").should == RDF::XSD.integer.to_s
      end
      it "should identify float types" do
        @parser.type_from_data_value(0.0).should == RDF::XSD.float.to_s
        @parser.type_from_data_value(-0.0).should == RDF::XSD.float.to_s
        @parser.type_from_data_value(123.45).should == RDF::XSD.float.to_s
        @parser.type_from_data_value(-123.45).should == RDF::XSD.float.to_s
        @parser.type_from_data_value("10,123.45").should == RDF::XSD.float.to_s
        @parser.type_from_data_value("-10,123.45567").should == RDF::XSD.float.to_s
      end
      it "should identify time types" do
        @parser.type_from_data_value("12:30:45 pm").should == RDF::XSD.time.to_s
        @parser.type_from_data_value("16:40").should == RDF::XSD.time.to_s
        @parser.type_from_data_value("16:40:32").should == RDF::XSD.time.to_s
      end
      it "should identify date types" do
        @parser.type_from_data_value("04/04/1964").should == RDF::XSD.date.to_s
        @parser.type_from_data_value("1/1/1964").should == RDF::XSD.date.to_s
        @parser.type_from_data_value("10/23/2001").should == RDF::XSD.date.to_s
        @parser.type_from_data_value("1/1/64").should == RDF::XSD.date.to_s
        @parser.type_from_data_value("10/23/01").should == RDF::XSD.date.to_s
      end
      it "should identify dateTime types" do
        @parser.type_from_data_value("04/04/1964 12:59 AM").should == RDF::XSD.dateTime.to_s
        @parser.type_from_data_value("10/10/2010 04:15 PM").should == RDF::XSD.dateTime.to_s
        @parser.type_from_data_value("5/16/2011 2:02:23 PM").should == RDF::XSD.dateTime.to_s
      end
      it "should identify boolean types" do
        @parser.type_from_data_value("TRUE").should == RDF::XSD.boolean.to_s
        @parser.type_from_data_value("false").should == RDF::XSD.boolean.to_s
      end
      it "should identify string types" do
        @parser.type_from_data_value("it was a dark and stormy night").should == RDF::XSD.string.to_s
        @parser.type_from_data_value("12buckle my shoe").should == RDF::XSD.string.to_s
        @parser.type_from_data_value("12 buckle my shoe").should == RDF::XSD.string.to_s
      end
    end
  end
  
  describe "basics" do
  end
  
end