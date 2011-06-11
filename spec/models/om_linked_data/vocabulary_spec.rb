require 'spec_helper'

describe OmLinkedData::Vocabulary do

  before(:each) do
    @uri = "http://dcgov.civicopenmedia.us"
    @col_label = "Education"
    @collection = OmLinkedData::Collection.new(:label=>@col_label, 
                                              :base_uri => @uri,
                                              :tags=>["schools", "teachers", "students"], 
                                              :comment => "Matters associated with public schools")
    @collection.save!
    
    @label = "Reading Proficiency-Third Grade"
    @vocabulary = OmLinkedData::Vocabulary.new(:label => @label, 
                            :collection => @collection,
                            :base_uri => @uri,
                            :tags => ["reading", "testing", "third grade"], 
                            :comment => "Percentage of children in third grade who read on grade level")
  end
  
  it 'should fail to initialize instance without a label, collection and base_uri' do
    lambda {  @bad_vocab = OmLinkedData::Vocabulary.new().save! }.should raise_error
    lambda {  @bad_vocab = OmLinkedData::Vocabulary.new(:label => @label).save! }.should raise_error
    lambda {  @bad_vocab = OmLinkedData::Vocabulary.new(:collection => @collection).save! }.should raise_error
    lambda {  @bad_vocab = OmLinkedData::Vocabulary.new(:base_uri => @uri).save! }.should raise_error
  end

  it 'should save and generate an identifier correctly' do
    lambda { @vocabulary.save! }.should change(OmLinkedData::Vocabulary, :count).by(1)
    @res = OmLinkedData::Vocabulary.by_label(:key => @label)
    @res[0].identifier.should == 'vocabulary_civicopenmedia_us_dcgov_reading_proficiency_third_grade'
  end

  it 'should return this Vocabulary when searching by URI' do
    @res = @vocabulary.save
    @res.uri.should == "http://civicopenmedia.us/dcgov/vocabularies#reading_proficiency_third_grade"
    @vocabs = OmLinkedData::Vocabulary.by_uri(:key => @res.uri)
    @vocabs.length.should == 1
    @vocabs[0].label.should == "Reading Proficiency-Third Grade"
  end
  
  it 'should return this Vocabulary when searching by Collection' do
    @vocabulary.save!
    @vocabs = OmLinkedData::Vocabulary.find_by_collection_id(@collection.identifier)
    @vocabs[0].label.should == "Reading Proficiency-Third Grade"
  end
  
  it 'should use tags view to return matching docs' do
    @vocabulary.save!
    @res = OmLinkedData::Vocabulary.by_tags(:key => "xyxyxy")
    @res.length.should == 0 
    @res = OmLinkedData::Vocabulary.by_tags(:key => "testing")
    @res[0].identifier.should == 'vocabulary_civicopenmedia_us_dcgov_reading_proficiency_third_grade'
  end

  # it "should use has_geometry view to return matching docs" do
  #   @vocabulary.save!
  #   @res = OmLinkedData::Vocabulary.by_has_geometry.length.should == 0
  #   @vocabulary.geometries << GeoJson::Point.new(GeoJson::Position.new([30, 60]))
  #   @vocabulary.save!
  #   @res = OmLinkedData::Vocabulary.by_has_geometry.length.should == 1
  # end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
