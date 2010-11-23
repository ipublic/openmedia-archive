require 'spec_helper'

describe OpenMedia::Dataset do

  before(:each) do
    reset_test_db!
    @catalog = OpenMedia::Catalog.create!(:title=>'Test Catalog', :metadata => { })
    @dataset = OpenMedia::Dataset.new(:title=>'4. Crime Test 3')
    @dataset.catalogs = [@catalog]
  end
  
  it 'should be a couchdb design document' do
    @dataset.should be_a_kind_of CouchRest::Design      
  end

  it 'should generate a safe class name' do
    @dataset.class_name.should == 'CrimeTest3'
  end

  it 'should require at least one catalog' do
    @dataset.catalog_ids = []
    @dataset.should_not be_valid
    @dataset.errors[:catalog_ids].should_not be_nil
  end
  
  it 'should save and generate id as _design/Dataset/class_name' do
    @dataset.save
    @dataset.persisted?.should be_true
    @dataset.catalogs.size.should == 1
    @dataset.id.should == '_design/Dataset/CrimeTest3'
  end

  it 'should allow access to all datasets' do
    @dataset.save
    ds2 = OpenMedia::Dataset.new(:title=>'dataset 2')
    ds2.catalogs = [@catalog]
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
    ds2.catalogs = [@catalog]
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
    d2 = OpenMedia::Dataset.get('_design/Dataset/CrimeTest3')
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

  it 'should know which catalogs it belongs to' do
    @dataset.save!    
    c1 = OpenMedia::Catalog.create!(:title=>'C1', :metadata=>{ })
    c2 = OpenMedia::Catalog.create!(:title=>'C2', :metadata=>{ })
    c1.datasets << @dataset; c1.save
    c2.datasets << @dataset; c2.save
    @dataset = OpenMedia::Dataset.get(@dataset.id)  # reload from db
    @dataset.catalogs.size.should == 3
    @dataset.catalogs[0].title.should == 'C1'
    @dataset.catalogs[1].title.should == 'C2'
    @dataset = OpenMedia::Dataset.first
    @dataset.catalog_ids.should == [c1.id, c2.id, @catalog.id]
  end

  it 'should allow catalogs to be set' do
    c1 = OpenMedia::Catalog.create!(:title=>'C1', :metadata=>{ })
    c2 = OpenMedia::Catalog.create!(:title=>'C2', :metadata=>{ })    
    @dataset.catalog_ids = [c1.id, c2.id]
    @dataset.save!
    
    c1 = OpenMedia::Catalog.get(c1.id)
    c2 = OpenMedia::Catalog.get(c2.id)
    @dataset = OpenMedia::Dataset.get(@dataset.id)
    c1.dataset_ids.should == [@dataset.id]
    c2.dataset_ids.should == [@dataset.id]
    @dataset.catalogs.size.should == 2
    @dataset.catalogs.should == [c1, c2]
  end
  
  it 'should be searchable by title' do
    %w(Apples Applications Bananas).each do |t|
      ds = OpenMedia::Dataset.new(:title=>t)
      ds.catalogs = [@catalog]
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
  
  
end
