require 'spec_helper'

describe LinkedData::Property do

  before(:each) do
    ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    core = LinkedData::Collection.create!(:base_uri => ns.base_uri, 
                                      :term => 'Core', 
                                      :authority => ns.authority)
                                      
    ps = LinkedData::Collection.create!(:base_uri => ns.base_uri, 
                                    :term => "public_safety",
                                    :label => "Public Safety",
                                    :authority => ns.authority)
    
    @xsd = ::LinkedData::Vocabulary.create!(:base_uri => "http://www.w3.org/2001",
                                        :collection => core,
                                        :term => "XMLSchema",
                                        :property_delimiter => "#"
                                        )

    @crime = LinkedData::Vocabulary.create!(:base_uri => ns.base_uri,
                                        :collection => ps,
                                        :term => "crime_reports",
                                        :label => "Crime Reports",
                                        :property_delimiter => "#"
                                        )
    
    @int = LinkedData::Type.create!(:vocabulary => @xsd, :term => "integer", :label => "Integer")
    @lng = LinkedData::Type.create!(:vocabulary => @xsd, :term => "long", :label => "Long")
    @str = LinkedData::Type.create!(:vocabulary => @xsd, :term => "string", :label => "String")
    
    @offense = LinkedData::Property.new(:vocabulary => @crime, 
                                         :term => "Offense", 
                                         :expected_type => @str)
  end
  
  it 'should fail to initialize instance without both a label and namespace' do
    lambda { LinkedData::Property.create!() }.should raise_error
    lambda { LinkedData::Property.create!(:label => @label) }.should raise_error
    lambda { LinkedData::Property.create!(:vocabulary => @crime) }.should raise_error
  end
  
  it 'should save and generate an identifier correctly' do
    @method = LinkedData::Property.new(:vocabulary => @crime, 
                                       :term => "Method", 
                                       :term => "method", 
                                       :expected_type => @str)
                                         
    lambda { @method.save! }.should change(LinkedData::Property, :count).by(1)
  end

  it 'should generate a Label view and return results correctly' do
    @method = LinkedData::Property.create!(:vocabulary => @crime, 
                                       :term => "method", 
                                       :label => "Method", 
                                       :expected_type => @str)

    @prop = LinkedData::Property.by_label(:key => "Method")
    @prop.rows[0].id.should == 'property_civicopenmedia_us_dcgov_crime_reports_method'
  end

  it 'should generate a URI for the new property' do
    @method = LinkedData::Property.create!(:vocabulary => @crime,
                                           :term => "method", 
                                           :label => "Method", 
                                           :expected_type => @str)

    @prop = LinkedData::Property.get(@method.id)
    @prop.uri.should == 'http://civicopenmedia.us/dcgov/vocabularies/crime_reports#method'
  end
  
end

