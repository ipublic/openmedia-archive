require 'spec_helper'

describe GeoJson::Point do
  before(:each) do
    @pos1 = GeoJson::Position.new([1,2])
    @pos2 = GeoJson::Position.new([3,4])
  end
  
  describe "class methods" do
    describe ".initialize" do
      it 'should create a Point instance with single coordinates' do
        @pt = GeoJson::Point.new([@pos1])
        @pt.type.should == GeoJson::Geometry::POINT_TYPE
        @pt.coordinates.should == @pos1
      end
    end
  end

end