require 'spec_helper'

describe LinkedData::DataResource do

  before(:each) do
    @dr_term = "reported_crimes"
    @dr = LinkedData::DataResource.new(:database => TYPES_DATABASE, :term => @dr_term)
  end
  
  describe "initialization" do
    it 'should fail to initialize instance without term property' do
      @dr = LinkedData::DataResource.new
      @dr.should_not be_valid
      @dr.errors[:term].should_not be_nil
      lambda { LinkedData::DataResource.create!(:term => @dr_term) }.should_not raise_error
    end
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
    it "should create a Vocabulary from source data content" do
    end
    
    it "should extract and parse records from source data content" do
    end
    
    it "should load raw records into CouchDB from source data content" do
    end
    
    it "should transform raw records into published data sets" do 
    end
  end
  
end