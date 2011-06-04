require 'spec_helper'

describe OmLinkedData::Collection do

  before(:each) do
    @uri = "http://dcgov.civicopenmedia.us/vocabulary/"
    @ns = OmLinkedData::Namespace.new(@uri)
    @collection = OmLinkedData::Collection.new(:label=>"Education", 
                                          :authority => @ns.authority,
                                          :tags=>["schools", "teachers", "students"], 
                                          :comment => "Matters associated with public schools")
  end
  
  it 'should save and generate an identifier correctly' do
    lambda { @collection.save! }.should change(OmLinkedData::Collection, :count).by(1)
    @collection.label.should == "Education"
    @collection.identifier.should == 'collection_dcgov_civicopenmedia_us_education'
  end
  
  it 'should return this Collection when searching by Namespace Authority' do
    @collection.save!
    @col = OmLinkedData::Collection.find_by_authority(@ns.authority)
    @col.label.should == "Education"
  end
  
  it 'should use tags view to return matching docs' do
    @collection.save!
    @res = OmLinkedData::Collection.by_tags(:key => "fire")
    @res.length.should == 0 
    @res = OmLinkedData::Collection.by_tags(:key => "teachers")
    @res[0].identifier.should == 'collection_dcgov_civicopenmedia_us_education'
  end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
