require 'spec_helper'

describe GeoJson::Position do

  describe "class methods" do
    describe ".initialize" do
      it "should create a position instance with two coordinate values" do
        pos = GeoJson::Position.new([1,2])
        pos.should === [1,2]
      end
      
      it "should create a position with three coordinate values" do
        pos = GeoJson::Position.new([0,1,2])
        pos.should === [0,1,2]
      end
    end  
  end
end