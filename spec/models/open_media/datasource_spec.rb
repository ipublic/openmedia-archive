require 'spec_helper'

describe OpenMedia::Datasource do

  before(:all) do
    reset_test_db!
    create_test_csv    
        
    @datasource = OpenMedia::Datasource.new(:title=>'4. Crime Test 3',
                                            :source_type=>OpenMedia::Datasource::FILE_TYPE, :parser=>OpenMedia::Datasource::DELIMITED_PARSER,
                                            :skip_lines=>1,
                                            :source_properties=>[{:label=>'A', :range_uri=>RDF::XSD.string},
                                                                 {:label=>'B', :range_uri=>RDF::XSD.string},
                                                                 {:label=>'C', :range_uri=>RDF::XSD.string},
                                                                 {:label=>'D', :range_uri=>RDF::XSD.string}])

    @datasource_class = create_test_rdfs_class(:label=>@datasource.title + ' Class',
                                               :properties=>[{:label=>'A', :range=>RDF::XSD.string},
                                                             {:label=>'B', :range=>RDF::XSD.string},
                                                             {:label=>'C', :range=>RDF::XSD.string},
                                                             {:label=>'D', :range=>RDF::XSD.string}])
    
    @datasource.rdfs_class_uri = @datasource_class.uri
    @datasource.save!
  end

  after(:all) do
    # delete_test_csv
  end
    
    
  it 'should require a type, source_type, and parser' do
    datasource = OpenMedia::Datasource.new
    datasource.should_not be_valid
    datasource.errors[:rdfs_class_uri].should_not be_nil
    datasource.errors[:source_type].should_not be_nil
    datasource.errors[:parser].should_not be_nil    
  end

  it 'should know how to load its rdfs_class' do
    @datasource.rdfs_class.should be_instance_of(OpenMedia::Schema::RDFS::Class)
    @datasource.rdfs_class.uri.should == @datasource_class.uri
  end
              
  it 'should be searchable by title' do
    %w(Apples Applications Bananas).each do |t|
      ds = OpenMedia::Datasource.create!(:title=>t, :rdfs_class_uri=>@datasource_class.uri,
                                         :source_type=>OpenMedia::Datasource::FILE_TYPE, :parser=>OpenMedia::Datasource::DELIMITED_PARSER)
    end
  
    OpenMedia::Datasource.search('App').size.should == 2
    OpenMedia::Datasource.search('Ban').size.should == 1
  end

  describe 'validation' do
    it 'should require a title' do
      lambda{ OpenMedia::Datasource.create! }.should raise_error
    end
  
    it 'should require titles to be unique' do
      @datasource.save!
      dd2 = OpenMedia::Datasource.new(:title=>'4. Crime Test 3')
      dd2.save.should be_false
      dd2.should_not be_valid
      dd2.errors[:title].should_not be_nil
    end
  
    it 'should allow updates' do
      @datasource.save!
      @datasource.metadata = { :description => 'Test test' }
      lambda { @datasource.save! }.should_not raise_error
    end
  end
  
   
  describe 'metadata' do
    it 'should save' do
      @datasource.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
      @datasource.save
      ds = OpenMedia::Datasource.get(@datasource.id)
      OpenMedia::Datasource.get(@datasource.id).metadata.title.should == 'Meta Title'
    end
  
    it 'should have creator association' do
      creator = OpenMedia::Organization.create!(:name=>'Org 1')
      @datasource.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
      @datasource.metadata.creator = creator
      @datasource.save
  
      OpenMedia::Datasource.get(@datasource.id).metadata.creator.id.should == creator.id
    end
  
    it 'should have publisher association' do
      publisher = OpenMedia::Organization.create!(:name=>'Org 2')
      @datasource.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
      @datasource.metadata.publisher = publisher
      @datasource.save
  
      OpenMedia::Datasource.get(@datasource.id).metadata.publisher.id.should == publisher.id
    end
  
    it 'should have maintainer association' do
      maintainer = OpenMedia::Organization.create!(:name=>'Org 3')
      @datasource.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
      @datasource.metadata.maintainer = maintainer
      @datasource.save
  
      OpenMedia::Datasource.get(@datasource.id).metadata.maintainer.id.should == maintainer.id
    end
  
  end

  describe 'importing' do
      
    it 'should require a file to be passed in options for import from a file source' do
      lambda { @datasource.import! }.should raise_error(ETL::ControlError)
      lambda { @datasource.import!(:file=>'/tmp/test.csv') }.should_not raise_error(ETL::ControlError)      
    end

    it 'should create a new OpenMedia::Import' do
      lambda { @datasource.import!({:file=>'/tmp/test.csv'}) }.should change(OpenMedia::Import, :count).by(1)
      OpenMedia::Import.last.created_at.should_not be_nil
      OpenMedia::Import.last.status.should == OpenMedia::Import::STATUS_COMPLETED      
    end 
        
    it 'should import data from files using OpenMedia::ETL::Engine' do
      @datasource.rdfs_class.spira_resource.each {|r| r.destroy! }
      lambda { @datasource.import!({:file=>'/tmp/test.csv'}) }.should change(@datasource.rdfs_class.spira_resource, :count).by(2)
      @datasource.rdfs_class.spira_resource.each.to_a.first.attributes.keys.collect{|k| k.to_s}.sort.should == %w(a b c created d modified)
    end
  
    it 'should map source properties to datasource properties properly'
  
    it 'should do type transformations based on property types'
    
  end
  
end
