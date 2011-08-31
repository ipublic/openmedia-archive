require 'spec_helper'

describe LinkedData::Collection do

  before(:each) do
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    @uri = @ns.base_uri
    @collection = LinkedData::Collection.new(:label=>"Education", 
                                          :base_uri => @uri,
                                          :authority => @ns.authority,
                                          :tags => ["schools", "teachers", "students"], 
                                          :comment => "Matters associated with public schools")
  end
  
  it 'should fail to initialize instance without both a label and base_uri' do
    lambda {  @bad_collection = LinkedData::Collection.new().save! }.should raise_error
    lambda {  @bad_collection = LinkedData::Collection.new(:label => @label).save! }.should raise_error
    lambda {  @bad_collection = LinkedData::Collection.new(:base_uri => @uri).save! }.should raise_error
  end

  it 'should save and generate an identifier correctly' do
    lambda { @collection.save! }.should change(LinkedData::Collection, :count).by(1)
  end
  
  it 'should generate a Label view and return results correctly' do
    @res = @collection.save
    @col = LinkedData::Collection.find_by_label(@res.label)
    @col.identifier.should == 'collection_civicopenmedia_us_dcgov_education'
  end

  it 'should generate a URI for the new collection' do
    @res = @collection.save
    @col = LinkedData::Collection.find(@res["_id"])
    @col.uri.should == 'http://civicopenmedia.us/dcgov/collections#education'
  end
  
  it 'should use tags view to return matching docs' do
    @collection.save!
    @res = LinkedData::Collection.tag_list(:key => "fire")
    @res.length.should == 0 
    @res = LinkedData::Collection.tag_list(:key => "teachers")
    @res.rows[0].id.should == 'collection_civicopenmedia_us_dcgov_education'
  end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
