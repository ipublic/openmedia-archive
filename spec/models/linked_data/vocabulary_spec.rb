require 'spec_helper'

describe LinkedData::Vocabulary do

  before(:each) do
    @uri = "http://civicopenmedia.us/vocabulary/"
    @abbrev = "om"
    @site_namespace = LinkedData::Namespace.new(:uri => @uri, :abbreviation => @abbrev)
    @site_namespace.save!
    @site_id = @site_namespace.identifier
    @collection = LinkedData::Collection.new(:label=>"Education", :tags=>["schools", "teachers", "students"], 
                                         :comment => "Matters associated with public schools",
                                         :namespace => @site_namespace)
    @collection.save!
    @label = "Reading Proficiency-Third Grade"
    @vocabulary = LinkedData::Vocabulary.new(:label => @label, :tags => ["reading", "testing", "third grade"], 
                                         :comment => "Percentage of children in third grade who read on grade level",
                                         :collection => @collection,
                                         :namespace => @site_namespace)
  end
  
  it 'should save and generate an identifier correctly' do
    lambda { @vocabulary.save! }.should change(LinkedData::Vocabulary, :count).by(1)
    @res = LinkedData::Vocabulary.by_label(:key => @label)
    @res[0].identifier.should == 'vocabulary_civicopenmedia_us_reading_proficiency_third_grade'
  end

  it 'should return this Vocabulary when searching by Namespace' do
    @vocabulary.save!
    @ns = LinkedData::Namespace.get(@site_id)
    @vocabs = LinkedData::Vocabulary.find_by_namespace_id(@ns.identifier)
    @vocabs[0].label.should == "Reading Proficiency-Third Grade"
  end
  
  it 'should return this Vocabulary when searching by Collection' do
    @vocabulary.save!
    @vocabs = LinkedData::Vocabulary.find_by_collection_id(@collection.identifier)
    @vocabs[0].label.should == "Reading Proficiency-Third Grade"
  end
  
  it 'should use tags view to return matching docs' do
    @vocabulary.save!
    @res = LinkedData::Vocabulary.by_tags(:key => "xyxyxy")
    @res.length.should == 0 
    @res = LinkedData::Vocabulary.by_tags(:key => "testing")
    @res[0].identifier.should == 'vocabulary_civicopenmedia_us_reading_proficiency_third_grade'
  end

  it "should use has_geometry view to return matching docs" do
    @vocabulary.save!
    @res = LinkedData::Vocabulary.by_has_geometry.length.should == 0
    @vocabulary.geometries << GeoJson::Point.new(GeoJson::Position.new([30, 60]))
    @vocabulary.save!
    @res = LinkedData::Vocabulary.by_has_geometry.length.should == 1
  end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
