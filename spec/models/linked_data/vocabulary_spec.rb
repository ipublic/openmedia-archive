require 'spec_helper'

describe LinkedData::Vocabulary do

  before(:each) do
    VOCABULARIES_DATABASE.recreate! rescue nil
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    @col_label = "Education"
    @term = "education"
    @label = "Reading Proficiency-Third Grade"
    @authority = @ns.authority
    @base_uri = @ns.base_uri
    @collection = LinkedData::Collection.create!(:term => @term,
                                                 :label => @col_label, 
                                                 :base_uri => @base_uri,
                                                 :authority => @ns.authority,
                                                 :tags=>["schools", "teachers", "students"], 
                                                 :comment => "Matters associated with public schools")
    
    @vocabulary = LinkedData::Vocabulary.new(:label => @col_label,
                            :term => @term,
                            :base_uri => @base_uri,
                            :authority => @ns.authority,
                            :tags => ["reading", "testing", "third grade"], 
                            :comment => "Percentage of children in third grade who read on grade level")
                            
    @vocab_uri = "http://civicopenmedia.us/dcgov/vocabularies/education"
    @vocab_id = "vocabulary_civicopenmedia_us_dcgov_education"
  
  end
  
  
  it 'should fail to initialize instance without a term, authority and base_uri' do
    @v = LinkedData::Vocabulary.new
    @v.should_not be_valid
    @v.errors[:term].should_not be_nil
    @v.errors[:authority].should_not be_nil
    @v.errors[:base_uri].should_not be_nil
    lambda { LinkedData::Vocabulary.create!(:base_uri => @base_uri, :term => "percent_promoted", :authority => @authority) }.should_not raise_error
  end

  it 'should save and generate an identifier correctly' do
    lambda { @vocabulary.save! }.should change(LinkedData::Vocabulary, :count).by(1)
    @res = LinkedData::Vocabulary.get(@vocab_id)
    @res.uri.should == @vocab_uri
  end

  it 'should recognize a local vocabulary and generate correct URI' do
    lcl_vocab = LinkedData::Vocabulary.create!(:label => "LocalVocabulary",
                                                 :term => "LocalVocabulary",
                                                 :base_uri => @base_uri, 
                                                 :authority => @authority,
                                                 :curie_prefix => "om",
                                                 :comment => "Datatypes defined on local OM site"
                                                 )
                                                
    vocab = LinkedData::Vocabulary.get(lcl_vocab.id)
    vocab.id.should == "vocabulary_civicopenmedia_us_dcgov_localvocabulary"
  end
  
  it 'should recognize an external vocabulary and generate correct URI' do
    xsd_vocab = LinkedData::Vocabulary.create!(:label => "XMLSchema",
                                                  :term => "XMLSchema",
                                                  :base_uri => "http://www.w3.org/2001", 
                                                  :authority => @authority,
                                                  :curie_prefix => "xsd",
                                                  :comment => "Datatypes defined in XML schemas"
                                                  )
                                                
    vocab = LinkedData::Vocabulary.get(xsd_vocab.id)
    vocab.id.should == "vocabulary_civicopenmedia_us_dcgov_xmlschema"
  end
  

  it 'should return this Vocabulary when searching by URI' do
    @res = @vocabulary.save
    @res.uri.should == @vocab_uri
    @vocabs = LinkedData::Vocabulary.by_uri(:key => @res.uri)
    @vocabs.length.should == 1
    @vocabs.rows.first.id.should == "vocabulary_civicopenmedia_us_dcgov_education"
  end
  
  it 'should return this Vocabulary when searching by Collection' do
  end
  
  it 'should use tags view to return matching docs' do
    @vocabulary.save!
    @res = LinkedData::Vocabulary.tag_list(:key => "xyxyxy")
    @res.length.should == 0 
    @res = LinkedData::Vocabulary.tag_list(:key => "testing")
    @res.rows.first.id.should == @vocab_id
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
