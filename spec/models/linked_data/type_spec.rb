require 'spec_helper'

describe LinkedData::Type do
  before(:each) do
    VOCABULARIES_DATABASE.recreate! rescue nil
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    @uri = @ns.base_uri
    @col_label = "Public Safety"
    
    @vocab_label = "Crime"
    @crime = LinkedData::Vocabulary.create!(:base_uri => @uri,
                                            :label => @vocab_label,
                                            :term => @vocab_label, 
                                            :authority => @ns.authority,
                                            :property_delimiter => "#"
                                            )


    @xsd = ::LinkedData::Vocabulary.create!(:base_uri => "http://www.w3.org/2001", 
                                            :label => "XMLSchema",
                                            :term => "XMLSchema",
                                            :property_delimiter => "#",
                                            :curie_prefix => "xsd",
                                            :authority => @ns.authority,
                                            :comment => "Datatypes defined in XML schemas"
                                            )

    @str = LinkedData::Type.create!(:vocabulary => @xsd, :term => "string")
    @str_uri = 'http://www.w3.org/2001/XMLSchema#string'
    @int_uri = 'http://www.w3.org/2001/XMLSchema#integer'
    @int_id = "type_civicopenmedia_us_dcgov_xmlschema_integer"

  end
  
  it 'should fail to initialize instance without term and vocabulary' do
    @ldt = OpenMedia::Datasource.new
    @ldt.should_not be_valid
    @ldt.errors[:term].should_not be_nil
    @ldt.errors[:vocabulary].should_not be_nil
    lambda { LinkedData::Type.create!(:vocabulary => @crime, :term => "integer") }.should_not raise_error
  end
  
  it 'should save and generate an identifier correctly' do
    term = "integer"
    int = LinkedData::Type.new(:vocabulary => @xsd, :term => term)

    lambda { int.save! }.should change(LinkedData::Type, :count).by(1)
    @res = LinkedData::Type.by_uri(:key => @int_uri)
    @res.rows.first.id.should == @int_id
  end
  
  it 'should return this Type when searching by Vocabulary' do
    term = "integer"
    int = LinkedData::Type.create!(:vocabulary => @xsd, :term => term)

    @types = LinkedData::Type.find_by_vocabulary_id(@xsd.id)
    @types.rows.first.id.should == @int_id
  end
  
  it 'should use tags view to return matching docs' do
    term = "integer"
    int = LinkedData::Type.create!(:vocabulary => @xsd, :term => term, :tags => ["core", "intrinsic"])

    int.save!
    @res = LinkedData::Type.tag_list(:key => "xyxyxy")
    @res.length.should == 0 
    @res = LinkedData::Type.tag_list(:key => "intrinsic")
    @res.rows.first.id.should == @int_id
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
