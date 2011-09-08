require 'spec_helper'

describe LinkedData::DataResource do

  before(:each) do
    @dr_term = "awesome"
    @dr = LinkedData::DataResource.new(:database => TYPES_DATABASE, :term => @dr_term)
  end
  
  describe "class methods" do
    describe ".create_design_doc" do
      it "should provide a Design document" do
        @res = @dr.create_design_doc
        @res["id"].should eql("_design/#{@dr_term}")
      end
    end
    
  end
  
  describe "basics" do
  end
  
end

