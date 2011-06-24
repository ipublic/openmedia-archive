require 'spec_helper'

describe OmLinkedData::Property do

  before(:each) do
    ns = OmLinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    core = OmLinkedData::Collection.new(:base_uri => ns.base_uri, :label=> 'Core', 
                                        :authority => ns.authority).save
    ps = OmLinkedData::Collection.new(:base_uri => ns.base_uri, :label => "Public Safety",
                                      :authority => ns.authority).save
    
    @xsd = ::OmLinkedData::Vocabulary.new(:base_uri => "http://www.w3.org/2001", 
                                          :collection => core,
                                          :label => "XMLSchema",
                                          :property_delimiter => "#"
                                          ).save

    @crime = OmLinkedData::Vocabulary.new(:base_uri => ns.base_uri,
                                          :collection => ps,
                                          :label => "Crime Reports",
                                          :property_delimiter => "#"
                                          ).save
    
    @int = OmLinkedData::Type.new(:vocabulary => @xsd, :label => "integer").save
    @lng = OmLinkedData::Type.new(:vocabulary => @xsd, :label => "long").save
    @str = OmLinkedData::Type.new(:vocabulary => @xsd, :label => "string").save
    

    @offense = OmLinkedData::Property.new(:vocabulary => @crime, 
                                         :label => "Offense", 
                                         :expected_type => @str)
  end
  
  it 'should fail to initialize instance without both a label and namespace' do
    lambda { OmLinkedData::Property.create!() }.should raise_error
    lambda {  @bad_property = OmLinkedData::Property.new(:label => @label).save! }.should raise_error
    lambda {  @bad_property = OmLinkedData::Property.new(:vocabulary => @crime).save! }.should raise_error
  end
  
  it 'should save and generate an identifier correctly' do
    @method = OmLinkedData::Property.new(:vocabulary => @crime, 
                                         :label => "Method", 
                                         :expected_type => @str)
                                         
    lambda { @method.save! }.should change(OmLinkedData::Property, :count).by(1)
  end

  it 'should generate a Label view and return results correctly' do
    @method = OmLinkedData::Property.new(:vocabulary => @crime, 
                                         :label => "Method", 
                                         :expected_type => @str)

    @res = @method.save
    @prop = OmLinkedData::Property.by_label(:key => "Method")
    @prop[0].identifier.should == 'property_civicopenmedia_us_dcgov_crime_reports_method'
  end

  it 'should generate a URI for the new property' do
    @method = OmLinkedData::Property.new(:vocabulary => @crime, 
                                         :label => "Method", 
                                         :expected_type => @str)
    @res = @method.save

    @prop = OmLinkedData::Property.get(@res.identifier)
    @prop.uri.should == 'http://civicopenmedia.us/dcgov/vocabularies/crime_reports#method'
  end
  
end

