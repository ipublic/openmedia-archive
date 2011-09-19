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
    
    describe ".to_json" do
      it 'should produce properly formed GeoJson output' do
        @mp = GeoJson::Point.new([@pos1, @pos2])
        gj = @mp.to_json
        gj['type'].should == GeoJson::Geometry::POINT_TYPE.to_s
        gj['coordinates'].should == @pos1
      end
    end
  end

end