require 'spec_helper'

describe LinkedData::ShapefileParser do

  before(:each) do
    @dr_term = "reported_crimes"
    @dr = LinkedData::DataResource.new(:database => TYPES_DATABASE, :term => @dr_term)
  end
  
  describe "class methods" do
    describe ".properties" do
    end
  end
  
  describe "basics" do
  end
  
end