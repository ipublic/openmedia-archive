require 'spec_helper'

describe OmLinkedData::Type do
  before(:each) do
    @ns = OmLinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    @uri = @ns.base_uri
    @col_label = "Public Safety"
    @collection = OmLinkedData::Collection.new(:label => @col_label, 
                                              :base_uri => @uri,
                                              :authority => @ns.authority
                                              ).save
    
    @vocab_label = "Crime"
    @vocabulary = OmLinkedData::Vocabulary.new(:base_uri => @uri,
                                              :term => @vocab_label, 
                                              :label => @vocab_label,
                                              :collection => @collection,
                                              :property_delimiter => "#"
                                              ).save


    @xsd = ::OmLinkedData::Vocabulary.new(:base_uri => "http://www.w3.org/2001", 
                                          :label => "XMLSchema",
                                          :term => "XMLSchema",
                                          :property_delimiter => "#",
                                          :curie_prefix => "xsd",
                                          :collection => @collection,
                                          :comment => "Datatypes defined in XML schemas"
                                          ).save

    @str = OmLinkedData::Type.new(:vocabulary => @xsd, :label => "string").save

  end
  
  it 'should fail to initialize instance without a label and vocabulary' do
    lambda {  @bad_vocab = OmLinkedData::Type.new().save! }.should raise_error
    lambda {  @bad_vocab = OmLinkedData::Type.new(:label => "integer").save! }.should raise_error
    lambda {  @bad_vocab = OmLinkedData::Type.new(:vocabulary => @vocabulary).save! }.should raise_error
  end

  it 'should save and generate an identifier correctly' do
    label = "integer"
    int = OmLinkedData::Type.new(:vocabulary => @xsd, :label => label)

    lambda { int.save! }.should change(OmLinkedData::Type, :count).by(1)
    @res = OmLinkedData::Type.by_label(:key => label)
    @res[0].identifier.should == 'type_civicopenmedia_us_dcgov_xmlschema_integer'
  end
  
  it 'should return this Type when searching by URI' do
    int = OmLinkedData::Type.new(:vocabulary => @xsd, :label => "integer")

    @res = int.save
    @res.uri.should == "http://www.w3.org/2001/XMLSchema#integer"
    @types = OmLinkedData::Type.by_uri(:key => @res.uri)
    @types.length.should == 1
    @types[0].label.should == "integer"
  end
  
  it 'should return this Type when searching by Vocabulary' do
    label = "integer"
    int = OmLinkedData::Type.new(:vocabulary => @xsd, :label => label)

    int.save!
    @types = OmLinkedData::Type.find_by_vocabulary_id(@xsd.identifier)
    @types[0].label.should == label
  end
  
  it 'should use tags view to return matching docs' do
    label = "integer"
    int = OmLinkedData::Type.new(:vocabulary => @xsd, :label => label, :tags => ["core", "intrinsic"])

    int.save!
    @res = OmLinkedData::Type.by_tags(:key => "xyxyxy")
    @res.length.should == 0 
    @res = OmLinkedData::Type.by_tags(:key => "intrinsic")
    @res[0].identifier.should == 'type_civicopenmedia_us_dcgov_xmlschema_integer'
  end
  
  it 'should save and return an external vocabulary and Type' do
    @type = OmLinkedData::Type.new(:vocabulary => @xsd, :label => "long").save
    @type.uri.should == "http://www.w3.org/2001/XMLSchema#long"
    @type.compound?.should == false
  end
  
  it 'should save and return a Compound Type' do 
    # geo = OmLinkedData::Vocabulary.new(:base_uri => "http://www.w3.org/2003/01/geo/", 
    #                                    :label => "W3C Geo Vocabulary",
    #                                    :term => "wgs84_pos",
    #                                    :property_delimiter => "#",
    #                                    :curie_prefix => "geo",
    #                                    :collection => @collection
    #                                   ).save
    # 
    # ::OmLinkedData::Type.create!(:vocabulary => geo, 
    #                              :label => "Latitude", 
    #                              :term => "lat",
    #                              :tags => ["northing", "coordinate"]
    #                              )
    # 
    # ::OmLinkedData::Type.create!(:vocabulary => geo_vocab, 
    #                           :label => "Longitude", 
    #                           :term => "long",
    #                           :tags => ["easting", "coordinate"]
    #                           )                              
    # 
    # point = OmLinkedData::Vocabulary.new(:base_uri => @ns.base_uri,
    #                                      :collection => @collection,
    #                                      :label => "Crime Reports",
    #                                      :property_delimiter => "#",
    #                                      :tags => ["police", "law enforcement", "justice"]
    #                                      ).save
    # 
    # 
    # method = OmLinkedData::Property.new(:vocabulary => crime, 
    #                                      :label => "Method", 
    #                                      :expected_type => @str).save
    # 
    # offense = OmLinkedData::Property.new(:vocabulary => crime, 
    #                                       :label => "Offense", 
    #                                       :expected_type => @str
    #                                       ).save
    # 
    # 
    # 
    # @type.properties << method << offense
    # @comp = @type.save
    # 
    # @comp.properties[0].label.should == "Method"
    # @comp.properties[0].expected_type.label.should == "string"
    # @comp.compound?.should == true
  end
  
    
end
