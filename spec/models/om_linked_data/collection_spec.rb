require 'spec_helper'

describe OmLinkedData::Collection do

  before(:each) do
    @uri = "http://dcgov.civicopenmedia.us"
    @collection = OmLinkedData::Collection.new(:label=>"Education", 
                                          :base_uri => @uri,
                                          :tags=>["schools", "teachers", "students"], 
                                          :comment => "Matters associated with public schools")
  end
  
  it 'should fail to initialize instance without both a label and namespace' do
    lambda {  @bad_collection = OmLinkedData::Collection.new().save! }.should raise_error
    lambda {  @bad_collection = OmLinkedData::Collection.new(:label => @label).save! }.should raise_error
    lambda {  @bad_collection = OmLinkedData::Collection.new(:base_uri => @ns).save! }.should raise_error
  end

  it 'should save and generate an identifier correctly' do
    lambda { @collection.save! }.should change(OmLinkedData::Collection, :count).by(1)
  end
  
  it 'should generate a Label view and return results correctly' do
    @res = @collection.save
    @col = OmLinkedData::Collection.find_by_label(@res.label)
    @col.identifier.should == 'collection_civicopenmedia_us_dcgov_education'
  end

  it 'should generate a URI for the new collection' do
    @res = @collection.save
    @col = OmLinkedData::Collection.find(@res["_id"])
    @col.uri.should == 'http://civicopenmedia.us/dcgov/collections#education'
  end
  
  it 'should use tags view to return matching docs' do
    @collection.save!
    @res = OmLinkedData::Collection.by_tags(:key => "fire")
    @res.length.should == 0 
    @res = OmLinkedData::Collection.by_tags(:key => "teachers")
    @res[0].identifier.should == 'collection_civicopenmedia_us_dcgov_education'
  end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
