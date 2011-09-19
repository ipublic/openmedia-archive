require 'spec_helper'

describe GeoJson::MultiPoint do
  before(:each) do
    @pos1 = GeoJson::Position.new([1,2])
    @pos2 = GeoJson::Position.new([3,4])
  end
  
  describe "class methods" do
    describe ".initialize" do
      it 'should create a MultiPoint instance with multiple coordinates' do
        @mp = GeoJson::MultiPoint.new([@pos1, @pos2])
        @mp.type.should == GeoJson::Geometry::MULTI_POINT_TYPE
        @mp.coordinates.first.should == @pos1
        @mp.coordinates.last.should == @pos2
      end
    end
    
    describe ".to_json" do
      it 'should produce properly formed GeoJson output' do
        @mp = GeoJson::MultiPoint.new([@pos1, @pos2])
        gj = @mp.to_json
        gj['type'].should == GeoJson::Geometry::MULTI_POINT_TYPE.to_s
        gj['coordinates'].first.should == @pos1
        gj['coordinates'].last.should == @pos2
      end
    end
  end
  

end