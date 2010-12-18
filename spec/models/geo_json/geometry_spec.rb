require 'spec_helper'

describe GeoJson::Geometry do
  describe GeoJson::Position do
    before(:each) do
      @boise_2d = [43.616667, -116.216667]
      @anchorage_3d = [61.110408, -149.904330, 92]
    end

    it 'should not accept < 2 coordinate lengths > 3' do
      lambda{ GeoJson::Position.new 1 }.should raise_error
      lambda{ GeoJson::Position.new 1, 2, 3, 4 }.should raise_error
    end
    
    it 'should not accept empty or invalid coordinate types' do
      lambda{ GeoJson::Position.new "a" }.should raise_error
      lambda{ GeoJson::Position.new }.should raise_error
    end

    it 'should accept two- and three-dimensional coordinates' do
      @pos0 = GeoJson::Position.new @boise_2d
      @pos1 = GeoJson::Position.new @anchorage_3d

      @pos0.should == [43.616667, -116.216667]
      @pos1.should == [61.110408, -149.904330, 92]
    end
  end
  
  describe GeoJson::Point do
    before(:each) do
      @boise_2d = [43.616667, -116.216667]
      @anchorage_3d = [61.110408, -149.904330, 92]
      @pos0 = GeoJson::Position.new @boise_2d
      @pos1 = GeoJson::Position.new @anchorage_3d
    end
    
    it 'should create points from valid 2D and 3D Positions' do
      @pt0 = GeoJson::Point.new @pos0
      @pt1 = GeoJson::Point.new @pos1

      @pt0["type"].should == "Point"
      @pt0["coordinates"].should == [43.616667, -116.216667]
      @pt1["type"].should == "Point"
      @pt1["coordinates"].should == [61.110408, -149.904330, 92]
    end
  end
  
  describe GeoJson::MultiPoint do
    before(:each) do
      @boise_2d = [43.616667, -116.216667]
      @anchorage_3d = [61.110408, -149.904330, 92]
      @pos0 = GeoJson::Position.new @boise_2d
      @pos1 = GeoJson::Position.new @anchorage_3d
    end
    
    it 'should create MuiltiPoints from valid 2D and 3D Position Arrays' do
      @mp0 = GeoJson::MultiPoint.new [@pos0, @pos0]
      @mp1 = GeoJson::MultiPoint.new [@pos1, @pos1]

      @mp0["type"].should == "MultiPoint"
      @mp0["coordinates"].size.should == 2
      @mp1["type"].should == "MultiPoint"
      @mp1["coordinates"].size.should == 2
    end
  end
  
end
