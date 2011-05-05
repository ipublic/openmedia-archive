require 'spec_helper'


describe OpenMedia::Site do

  before(:each) do
    reset_test_db!
    @site = OpenMedia::Site.new(:url=>'http://somesite.com')
  end
  
  it 'should save and generate an identifier correctly' do
    lambda { @site.save! }.should change(OpenMedia::Site, :count).by(1)
    @site.identifier.should == 'somesitecom'
  end

  it 'should assume http:// if protocol not specified in url' do
    @site.url = 'somesite.com'
    @site.save!
    @site.url.should == 'http://somesite.com'    
    @site.identifier.should == 'somesitecom'
  end

  it 'should create skos collection if it does not yet exist' do
    @site.save!
    lambda { @site.skos_collection }.should change(OpenMedia::Schema::SKOS::Collection, :count).by(1)
    @site.skos_collection.should be_instance_of(OpenMedia::Schema::SKOS::Collection)
    @site.skos_collection.uri.should === RDF::URI.new('http://data.civicopenmedia.org/somesitecom/concepts')
  end

  describe 'metadata repository' do
    it 'should return its metadata rdf repo (and create couch db if necessary)' do
      @site.metadata_repository.should == "#{@site.identifier}_metadata"
    end
  end

end
