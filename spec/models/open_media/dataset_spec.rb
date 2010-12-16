require 'spec_helper'

describe OpenMedia::Dataset do

  before(:each) do
    reset_test_db!
    @catalog = create_test_catalog
    @dataset = OpenMedia::Dataset.new(:title=>'4. Crime Test 3')
    @dataset.catalog = @catalog
  end
  
  it 'should be a couchdb design document' do
    @dataset.should be_a_kind_of CouchRest::Design      
  end
  
  it 'should generate a safe identifier' do
    @dataset.identifier.should == 'CrimeTest3'
  end
  
  it 'should require at least one catalog' do
    @dataset.catalog = nil
    @dataset.should_not be_valid
    @dataset.errors[:catalog_id].should_not be_nil
  end

  it 'should know how to get its catalog' do
    @dataset.save
    @dataset = OpenMedia::Dataset.find(@dataset.id)
    @dataset.catalog.title.should == @catalog.title
  end
  
  it 'should save and generate id as _design/ModelClassName' do
    @dataset.save
    @dataset.persisted?.should be_true
    @dataset.id.should == "_design/#{@dataset.model_name}"
  end
  
  it 'should allow access to all datasets' do
    @dataset.save
    ds2 = OpenMedia::Dataset.new(:title=>'dataset 2')
    ds2.catalog = @catalog
    ds2.save
    
    dd = CouchRest::Design.new
    dd.name='another design doc'
    dd.database = STAGING_DATABASE
    dd.save    
    OpenMedia::Dataset.all.size.should == 2
    OpenMedia::Dataset.all.each {|ds| ds.should be_instance_of OpenMedia::Dataset }
  end
  
  it 'should provide count of datasets' do
    @dataset.save
    ds2 = OpenMedia::Dataset.new(:title=>'dataset 2')
    ds2.catalog = @catalog
    ds2.save
    OpenMedia::Dataset.count.should == 2
    dd = CouchRest::Design.new
    dd.name='another design doc'
    dd.database = STAGING_DATABASE
    dd.save
    OpenMedia::Dataset.count.should == 2
  end
  
  it 'should be findable by id' do
    @dataset.save
    d2 = OpenMedia::Dataset.get('_design/OpenMedia::Dataset::CrimeTest3')
    d2.should_not be_nil
    d2.id.should == @dataset.id
    d2.title.should == @dataset.title
  end
  
  it 'should be findable by class_name' do
    @dataset.save
    d2 = OpenMedia::Dataset.get('CrimeTest3')
    d2.should_not be_nil
    d2.id.should == @dataset.id
    d2.title.should == @dataset.title
  end
  
  it 'should not generate a design document for querying Datasets (design docs cannot be queried with views)' do
    num_design_docs = STAGING_DATABASE.documents(:startkey => '_design', :endkey => '_design0')['rows'].size
    @dataset.save
    STAGING_DATABASE.documents(:startkey => '_design', :endkey => '_design0')['rows'].size.should == num_design_docs + 1
  end
      
  it 'should be searchable by title' do
    %w(Apples Applications Bananas).each do |t|
      ds = OpenMedia::Dataset.new(:title=>t)
      ds.catalog = @catalog
      ds.save!
    end
  
    OpenMedia::Dataset.search('App').size.should == 2
    OpenMedia::Dataset.search('Ban').size.should == 1
  end
  
  describe 'validation' do
    it 'should require a title' do
      lambda{ OpenMedia::Dataset.create! }.should raise_error
    end
  
    it 'should require titles to be unique' do
      @dataset.save!
      dd2 = OpenMedia::Dataset.new(:title=>'4. Crime Test 3')
      dd2.save.should be_false
      dd2.should_not be_valid
      dd2.errors[:title].should_not be_nil
    end
  
    it 'should allow updates' do
      @dataset.save!
      @dataset.metadata = { :description => 'Test test' }
      lambda { @dataset.save! }.should_not raise_error
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
  
  describe 'metadata' do
    it 'should save' do
      @dataset.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
      @dataset.save
      OpenMedia::Dataset.get(@dataset.id).metadata.title.should == 'Meta Title'
    end
  
    it 'should have creator association' do
      creator = OpenMedia::Organization.create!(:name=>'Org 1')
      @dataset.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
      @dataset.metadata.creator = creator
      @dataset.save
  
      OpenMedia::Dataset.get(@dataset.id).metadata.creator.id.should == creator.id
    end
  
    it 'should have publisher association' do
      publisher = OpenMedia::Organization.create!(:name=>'Org 1')
      @dataset.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
      @dataset.metadata.publisher = publisher
      @dataset.save
  
      OpenMedia::Dataset.get(@dataset.id).metadata.publisher.id.should == publisher.id
    end
  
    it 'should have maintainer association' do
      maintainer = OpenMedia::Organization.create!(:name=>'Org 1')
      @dataset.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
      @dataset.metadata.maintainer = maintainer
      @dataset.save
  
      OpenMedia::Dataset.get(@dataset.id).metadata.maintainer.id.should == maintainer.id
    end
  
  end
  
  describe 'importing' do
    before(:each) do
      reset_test_db!
      @csv_data = StringIO.new("A,B,C\n1,2,3\n4,5,6")
      @dataset.set_properties([{:name=>'A'},{:name=>'B'}, {:name=>'C'}])
      @dataset.import_data_file!(@csv_data, :has_header_row=>true, :delimiter_character=>',')            
    end

    it 'should allow dataset properties to be initialized' do
      @dataset.dataset_properties.size.should == 3
      @dataset.dataset_properties.collect{|p| p.name}.should == %w(A B C)
      @dataset.dataset_properties.collect{|p| p.data_type}.should == %w(string string string)
      @dataset.attachments.size.should == 1
    end
    
    it 'should generate a CouchRest::Model class for manipulating the data' do
      @dataset.model_name.should == 'OpenMedia::Dataset::CrimeTest3'
      @dataset.model.should == OpenMedia::Dataset::CrimeTest3
    end
    
    it 'should import data from files' do
      @dataset.model.count.should == 2
    end

    it 'should delete imported data when dataset is deleted' do
      @dataset = OpenMedia::Dataset.find(@dataset.id)
      num_docs = STAGING_DATABASE.documents['rows'].size
      @dataset.destroy
      STAGING_DATABASE.documents['rows'].size.should == (num_docs - 3)
    end

  end 
  
end
