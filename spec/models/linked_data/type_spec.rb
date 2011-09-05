require 'spec_helper'

describe LinkedData::Type do
  before(:each) do
    TYPES_DATABASE.recreate! rescue nil
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    @uri = @ns.base_uri
    @col_label = "Public Safety"
    @collection = LinkedData::Collection.create!(:term => @col_label, 
                                              :base_uri => @uri,
                                              :authority => @ns.authority
                                              )
    
    @vocab_label = "Crime"
    @crime = LinkedData::Vocabulary.create!(:base_uri => @uri,
                                              :term => @vocab_label, 
                                              :label => @vocab_label,
                                              :collection => @collection,
                                              :property_delimiter => "#"
                                              )


    @xsd = ::LinkedData::Vocabulary.create!(:base_uri => "http://www.w3.org/2001", 
                                          :label => "XMLSchema",
                                          :term => "XMLSchema",
                                          :property_delimiter => "#",
                                          :curie_prefix => "xsd",
                                          :collection => @collection,
                                          :comment => "Datatypes defined in XML schemas"
                                          )

    @str = LinkedData::Type.create!(:vocabulary => @xsd, :term => "string")
    @str_uri = 'http://www.w3.org/2001/XMLSchema#string'
    @int_uri = 'http://www.w3.org/2001/XMLSchema#integer'

  end
  
  it 'should fail to initialize instance without a term and vocabulary' do
    lambda { LinkedData::Type.create!() }.should raise_error
    lambda { LinkedData::Type.create!(:term => "integer") }.should raise_error
    lambda { LinkedData::Type.create!(:vocabulary => @crime) }.should raise_error
    lambda { LinkedData::Type.create!(:vocabulary => @crime, :term => "integer") }.should_not raise_error
  end

  it 'should save and generate an identifier correctly' do
    term = "integer"
    int = LinkedData::Type.new(:vocabulary => @xsd, :term => term)

    lambda { int.save! }.should change(LinkedData::Type, :count).by(1)
    @res = LinkedData::Type.get(@int_uri)
    @res.id.should == @int_uri
  end
  
  it 'should return this Type when searching by Vocabulary' do
    term = "integer"
    int = LinkedData::Type.create!(:vocabulary => @xsd, :term => term)

    @types = LinkedData::Type.find_by_vocabulary_id(@xsd.id)
    @types.rows[0].id.should == @int_uri
  end
  
  it 'should use tags view to return matching docs' do
    term = "integer"
    int = LinkedData::Type.create!(:vocabulary => @xsd, :term => term, :tags => ["core", "intrinsic"])

    int.save!
    @res = LinkedData::Type.tag_list(:key => "xyxyxy")
    @res.length.should == 0 
    @res = LinkedData::Type.tag_list(:key => "intrinsic")
    @res.rows[0].id.should == @int_uri
  end
  
  it 'should save and return an external vocabulary and Type' do
    @type = LinkedData::Type.create!(:vocabulary => @xsd, :term => "long")
    @type.uri.should == "http://www.w3.org/2001/XMLSchema#long"
    @type.compound?.should == false
  end
  
  it 'should save and return a Compound Type' do 
    cr = LinkedData::Type.new(:vocabulary => @crime, 
                              :label => "Crime Reports",
                              :term => "crime_reports"
                              )
    
    method = LinkedData::Property.new(:term => "Method", :expected_type => @str.uri)
    offense = LinkedData::Property.new(:term => "Offense", :expected_type => @str.uri)
                                     
    cr.properties << method << offense
    comp = cr.save
    
    res = LinkedData::Type.get(comp.id)
    
    res.properties[0].term.should == "Method"
    res.properties[0].expected_type.should == @str_uri
    res.compound?.should == true
  end
  
    
end
