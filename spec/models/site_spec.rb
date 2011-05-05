require 'spec_helper'


describe OpenMedia::Site do

  before(:each) do
    @site = OpenMedia::Site.new(:identifier=>'somesite', :municipality=>OpenMedia::NamedPlace.new(:name=>'My City'))
  end
  
  it 'should save and generate a url correctly' do
    lambda { @site.save! }.should change(OpenMedia::Site, :count).by(1)
    @site.identifier.should == 'somesite'
    @site.url.should == "http://somesite.#{OM_DOMAIN}"
  end

  it 'should create skos collection on first access if it does not yet exist' do
    @site.save!
    lambda { @site.skos_collection }.should change(OpenMedia::Schema::SKOS::Collection, :count).by(1)
    @site.skos_collection.should be_instance_of(OpenMedia::Schema::SKOS::Collection)
    @site.skos_collection.uri.should === 'http://data.civicopenmedia.org/somesite/concepts'
  end

  describe 'metadata repository' do
    it 'should return its metadata rdf repo (and create couch db if necessary)' do
      @site.metadata_repository.should == "#{@site.identifier}_metadata"
    end
  end

end
