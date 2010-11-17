require 'spec_helper'


describe OpenMedia::Dataset do

  before(:each) do
    reset_test_db!
    @dataset = OpenMedia::Dataset.new(:title=>'4. Crime Test 3')    
  end
  
  it 'should be a couchdb design document' do
    @dataset.should be_a_kind_of CouchRest::Design      
  end
  
  it 'should save and generate id as _design/Dataset/ClassName' do
    @dataset.save
    @dataset.persisted?.should be_true
    @dataset.id.should == '_design/Dataset/CrimeTest3'
  end

  it 'should allow access to all datasets' do
    @dataset.save
    OpenMedia::Dataset.create!(:title=>'dataset 2')
    dd = CouchRest::Design.new
    dd.name='another design doc'
    dd.database = STAGING_DATABASE
    dd.save    
    OpenMedia::Dataset.all.size.should == 2
    OpenMedia::Dataset.all.each {|ds| ds.should be_instance_of OpenMedia::Dataset }
  end

  it 'should provide count of datasets' do
    @dataset.save
    OpenMedia::Dataset.create!(:title=>'dataset 2')
    OpenMedia::Dataset.count.should == 2
    dd = CouchRest::Design.new
    dd.name='another design doc'
    dd.database = STAGING_DATABASE
    dd.save
    OpenMedia::Dataset.count.should == 2
  end

  it 'should provide access to single datasets' do
    @dataset.save
    d2 = OpenMedia::Dataset.find('_design/Dataset/CrimeTest3')
    d2.should_not be_nil
    d2.id.should == @dataset.id
    d2.title.should == @dataset.title
  end

  it 'should not generate a design document for querying Datasets (design docs cannot be queried with views)' do
    num_design_docs = STAGING_DATABASE.documents(:startkey => '_design', :endkey => '_design0')['rows'].size
    @dataset.save
    STAGING_DATABASE.documents(:startkey => '_design', :endkey => '_design0')['rows'].size.should == num_design_docs + 1
  end

  describe 'validation' do
    it 'should require a title' do
      lambda{ OpenMedia::Dataset.create! }.should raise_error
    end

    it 'should require titles to be unique' do
      @dataset.save
      dd2 = OpenMedia::Dataset.new(:title=>'4. Crime Test 3')
      dd2.save.should be_false
      dd2.should_not be_valid
      dd2.errors[:title].should_not be_nil
    end
  end

  describe "managing properties" do
    before(:each) do
      @prop0 = OpenMedia::Property.new(:name=>"Title", :type => "string", :is_key => true)
      @prop1 = OpenMedia::Property.new(:name=>"Category", :type => "string", :is_key => false, :example_value => "Science Fiction")
      @prop2 = OpenMedia::Property.new(:name=>"Rating", :type => "string", :example_value => "R")
    end
    
    it "should clear all properties" do
      @dataset.dataset_properties << @prop0
      @dataset.dataset_properties.size.should == 1
      @dataset.dataset_properties.clear
      @dataset.dataset_properties.should be_empty
    end

    it "should add and return a property by name" do
      @dataset.dataset_properties <<  @prop0
      rtn_prop = @dataset.get_dataset_property(@prop0.name)
      rtn_prop.name.should == @prop0.name
    end
   
    it "should return nil for a property that doesn't exist" do
      @dataset.dataset_properties.clear
      @dataset.dataset_properties <<  @prop0
      @dataset.get_dataset_property(@prop1.name).should == nil
    end
    
    
    it "should remove a property by name" do
      @dataset.dataset_properties <<  @prop0
      rtn_prop = @dataset.get_dataset_property(@prop0.name)
      rtn_prop.name.should == @prop0.name
      
      @dataset.delete_dataset_property(@prop0.name)
      @dataset.get_dataset_property(@prop0.name).should == nil
    end

  end
  
  
end
