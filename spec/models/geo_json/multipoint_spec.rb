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
      end
    end
  end
  

end