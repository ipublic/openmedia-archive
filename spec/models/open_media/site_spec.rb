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

  describe 'instance singleton method' do
    it 'should return first instance in couchdb' do
      @site.save!
      OpenMedia::Site.instance.id.should == @site.id
    end

    it 'should raise OpenMedia::NoSiteDefined exception if no site is in database' do
      lambda { OpenMedia::Site.instance }.should raise_error(OpenMedia::NoSiteDefined)
    end
  end

end
