require 'spec_helper'

describe LinkedData::Type do
  before(:each) do
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    @uri = @ns.base_uri
    @col_label = "Public Safety"
    @collection = LinkedData::Collection.new(:label => @col_label, 
                                              :base_uri => @uri,
                                              :authority => @ns.authority
                                              ).save
    
    @vocab_label = "Crime"
    @crime = LinkedData::Vocabulary.new(:base_uri => @uri,
                                              :term => @vocab_label, 
                                              :label => @vocab_label,
                                              :collection => @collection,
                                              :property_delimiter => "#"
                                              ).save


    @xsd = ::LinkedData::Vocabulary.new(:base_uri => "http://www.w3.org/2001", 
                                          :label => "XMLSchema",
                                          :term => "XMLSchema",
                                          :property_delimiter => "#",
                                          :curie_prefix => "xsd",
                                          :collection => @collection,
                                          :comment => "Datatypes defined in XML schemas"
                                          ).save

    @str = LinkedData::Type.new(:vocabulary => @xsd, :label => "string").save

  end
  
  it 'should fail to initialize instance without a label and vocabulary' do
    lambda {  @bad_vocab = LinkedData::Type.new().save! }.should raise_error
    lambda {  @bad_vocab = LinkedData::Type.new(:label => "integer").save! }.should raise_error
    lambda {  @bad_vocab = LinkedData::Type.new(:vocabulary => @crime).save! }.should raise_error
  end

  it 'should save and generate an identifier correctly' do
    label = "integer"
    int = LinkedData::Type.new(:vocabulary => @xsd, :label => label)

    lambda { int.save! }.should change(LinkedData::Type, :count).by(1)
    @res = LinkedData::Type.by_label(:key => label)
    @res.rows[0].id.should == 'type_civicopenmedia_us_dcgov_xmlschema_integer'
  end
  
  it 'should return this Type when searching by URI' do
    int = LinkedData::Type.new(:vocabulary => @xsd, :label => "integer")

    @res = int.save
    @res.uri.should == "http://www.w3.org/2001/XMLSchema#integer"
    @types = LinkedData::Type.by_uri(:key => @res.uri)
    @types.length.should == 1
    @types.rows[0].id.should == "type_civicopenmedia_us_dcgov_xmlschema_integer"
  end
  
  it 'should return this Type when searching by Vocabulary' do
    label = "integer"
    int = LinkedData::Type.new(:vocabulary => @xsd, :label => label)

    int.save!
    @types = LinkedData::Type.find_by_vocabulary_id(@xsd.identifier)
    @types.rows[0].id.should == "type_civicopenmedia_us_dcgov_xmlschema_integer"
  end
  
  it 'should use tags view to return matching docs' do
    label = "integer"
    int = LinkedData::Type.new(:vocabulary => @xsd, :label => label, :tags => ["core", "intrinsic"])

    int.save!
    @res = LinkedData::Type.tag_list(:key => "xyxyxy")
    @res.length.should == 0 
    @res = LinkedData::Type.tag_list(:key => "intrinsic")
    @res.rows[0].id.should == 'type_civicopenmedia_us_dcgov_xmlschema_integer'
  end
  
  it 'should save and return an external vocabulary and Type' do
    @type = LinkedData::Type.new(:vocabulary => @xsd, :label => "long").save
    @type.uri.should == "http://www.w3.org/2001/XMLSchema#long"
    @type.compound?.should == false
  end
  
  it 'should save and return a Compound Type' do 
    cr = LinkedData::Type.new(:vocabulary => @crime, 
                                :label => "Crime Reports"
                                )
    
    method = LinkedData::Property.new(:vocabulary => @crime, 
                                         :label => "Method", 
                                         :expected_type => @str).save
    offense = LinkedData::Property.new(:vocabulary => @crime, 
                                         :label => "Offense", 
                                         :expected_type => @str).save

                                     
    cr.properties << method << offense
    comp = cr.save
    
    res = LinkedData::Type.get comp.identifier
    
    res.properties[0].label.should == "Method"
    res.properties[0].expected_type.label.should == "string"
    res.compound?.should == true
  end
  
    
end
