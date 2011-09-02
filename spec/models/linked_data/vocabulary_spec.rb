require 'spec_helper'

describe LinkedData::Vocabulary do

  before(:each) do
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    @col_label = "Education"
    @term = "education"
    @authority = @ns.authority
    @base_uri = @ns.base_uri
    @collection = LinkedData::Collection.new(:term => @term,
                                             :label => @col_label, 
                                             :base_uri => @base_uri,
                                             :authority => @ns.authority,
                                             :tags=>["schools", "teachers", "students"], 
                                             :comment => "Matters associated with public schools")
    @collection.save!
    
    @label = "Reading Proficiency-Third Grade"
    @vocabulary = LinkedData::Vocabulary.new(:label => @label, 
                            :term => @label,
                            :collection => @collection,
                            :base_uri => @base_uri,
                            :tags => ["reading", "testing", "third grade"], 
                            :comment => "Percentage of children in third grade who read on grade level")
  
  end
  
  
  it 'should fail to initialize instance without a label, collection and base_uri' do
    lambda { LinkedData::Vocabulary.create!() }.should raise_error
    lambda { LinkedData::Vocabulary.create!(:term => @term) }.should raise_error
    lambda { LinkedData::Vocabulary.create!(:collection => @collection) }.should raise_error
    lambda { LinkedData::Vocabulary.create!(:base_uri => @base_uri) }.should raise_error
  end

  it 'should save and generate an identifier correctly' do
    lambda { @vocabulary.save! }.should change(LinkedData::Vocabulary, :count).by(1)
    @res = LinkedData::Vocabulary.by_label(:key => @label)
    @res.rows[0].id.should == 'vocabulary_civicopenmedia_us_dcgov_reading_proficiency_third_grade'
  end

  it 'should recognize a local vocabulary and generate correct URI' do
    lcl_vocab = ::LinkedData::Vocabulary.new(:label => "LocalVocabulary",
                                             :term => "LocalVocabulary",
                                             :base_uri => @base_uri, 
                                             :collection => @collection,
                                             :curie_prefix => "om",
                                             :comment => "Datatypes defined on local OM site"
                                             ).save
                                                
    vocab = ::LinkedData::Vocabulary.get(lcl_vocab.identifier)
    vocab.uri.should == "http://civicopenmedia.us/dcgov/vocabularies/LocalVocabulary"
  end
  
  it 'should recognize an external vocabulary and generate correct URI' do
    xsd_vocab = ::LinkedData::Vocabulary.new(:label => "XMLSchema",
                                              :term => "XMLSchema",
                                              :base_uri => "http://www.w3.org/2001", 
                                              :collection => @collection,
                                              :curie_prefix => "xsd",
                                              :comment => "Datatypes defined in XML schemas"
                                              ).save
                                                
    vocab = ::LinkedData::Vocabulary.get(xsd_vocab.identifier)
    vocab.uri.should == "http://www.w3.org/2001/XMLSchema"
  end
  

  it 'should return this Vocabulary when searching by URI' do
    @res = @vocabulary.save
    @res.uri.should == "http://civicopenmedia.us/dcgov/vocabularies/Reading_Proficiency_Third_Grade"
    @vocabs = LinkedData::Vocabulary.by_uri(:key => @res.uri)
    @vocabs.length.should == 1
    @vocabs.rows[0].id.should == "vocabulary_civicopenmedia_us_dcgov_reading_proficiency_third_grade"
  end
  
  it 'should return this Vocabulary when searching by Collection' do
    @vocabulary.save!
    @vocabs = LinkedData::Vocabulary.find_by_collection_id(@collection.identifier)
    @vocabs.rows[0].id.should == 'vocabulary_civicopenmedia_us_dcgov_reading_proficiency_third_grade'
  end
  
  it 'should use tags view to return matching docs' do
    @vocabulary.save!
    @res = LinkedData::Vocabulary.tag_list(:key => "xyxyxy")
    @res.length.should == 0 
    @res = LinkedData::Vocabulary.tag_list(:key => "testing")
    @res.rows[0].id.should == 'vocabulary_civicopenmedia_us_dcgov_reading_proficiency_third_grade'
  end

  # it "should use has_geometry view to return matching docs" do
  #   @vocabulary.save!
  #   @res = LinkedData::Vocabulary.by_has_geometry.length.should == 0
  #   @vocabulary.geometries << GeoJson::Point.new(GeoJson::Position.new([30, 60]))
  #   @vocabulary.save!
  #   @res = LinkedData::Vocabulary.by_has_geometry.length.should == 1
  # end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
