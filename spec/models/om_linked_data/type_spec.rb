require 'spec_helper'

describe OmLinkedData::Type do
  before(:each) do
    @uri = "http://dcgov.civicopenmedia.us"
    @col_label = "Public Safety"
    @collection = OmLinkedData::Collection.new(:label=>@col_label, 
                                              :base_uri => @uri
                                              )
    @collection.save!
    
    @vocab_label = "Crime"
    @vocabulary = OmLinkedData::Vocabulary.new(:label=>@vocab_label, 
                                              :base_uri => @uri,
                                              :collection => @collection
                                              )
    @vocabulary.save
    
    @label = "Offense"
    @type = OmLinkedData::Type.new(:label => @label, 
                                    :vocabulary => @vocabulary,
                                    :tags=>["police", "law enforcement", "justice"]
                                    )
  end
  
  it 'should fail to initialize instance without a label and vocabulary' do
    lambda {  @bad_vocab = OmLinkedData::Type.new().save! }.should raise_error
    lambda {  @bad_vocab = OmLinkedData::Type.new(:label => @label).save! }.should raise_error
    lambda {  @bad_vocab = OmLinkedData::Type.new(:vocabulary => @vocabulary).save! }.should raise_error
  end

  it 'should save and generate an identifier correctly' do
    lambda { @type.save! }.should change(OmLinkedData::Type, :count).by(1)
    @res = OmLinkedData::Type.by_label(:key => @label)
    @res[0].identifier.should == 'type_civicopenmedia_us_dcgov_offense'
  end
  
  it 'should return this Type when searching by URI' do
    @res = @type.save
    @res.uri.should == "http://civicopenmedia.us/dcgov/vocabularies#crime/offense"
    @types = OmLinkedData::Type.by_uri(:key => @res.uri)
    @types.length.should == 1
    @types[0].label.should == "Offense"
  end
  
  it 'should return this Type when searching by Vocabulary' do
    @type.save!
    @types = OmLinkedData::Type.find_by_vocabulary_id(@vocabulary.identifier)
    @types[0].label.should == "Offense"
  end
  
  it 'should use tags view to return matching docs' do
    @type.save!
    @res = OmLinkedData::Type.by_tags(:key => "xyxyxy")
    @res.length.should == 0 
    @res = OmLinkedData::Type.by_tags(:key => "police")
    @res[0].identifier.should == 'type_civicopenmedia_us_dcgov_offense'
  end
  
end
