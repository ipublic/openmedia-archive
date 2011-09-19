require 'spec_helper'

describe LinkedData::DataResource do

  before(:each) do
    @dr_term = "reported_crimes"
    @dr = LinkedData::DataResource.new(:database => VOCABULARIES_DATABASE, :term => @dr_term)
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
    describe ".batch_serial_number" do
      it "should generate a unique serial number using MD5 hash seeded by current time and random number" do
        @sn1 = @dr.batch_serial_number
        @sn2 = @dr.batch_serial_number
        @sn1.should_not == @sn2
      end
    end
    
    describe ".design_doc" do
      it "should provide a Design document" do
        @res = @dr.design_document(DB)
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

      # it "should append property constants to each OpenMedia:RawRecord" do
      #   @property_constants.each {|k,v| @record_list.first[k].should == v}
      # end

      
    end
    
    it "should transform raw records into published data sets" do 
    end
  end
  
end