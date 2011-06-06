require 'spec_helper'

describe OmLinkedData::Property do

  before(:each) do
    @label = "Method"
    @uri = "http://dcgov.civicopenmedia.us"
    # @property = OmLinkedData::Property.new(:label => @label, :authority => @ns.authority, :subdomain => @ns.subdomain)
    @property = OmLinkedData::Property.new(:label => @label, :base_uri => @uri)
  end
  
  it 'should fail to initialize instance without both a label and namespace' do
    lambda {  @bad_property = OmLinkedData::Property.new().save! }.should raise_error
    lambda {  @bad_property = OmLinkedData::Property.new(:label => @label).save! }.should raise_error
    lambda {  @bad_property = OmLinkedData::Property.new(:namespace => @ns).save! }.should raise_error
  end
  
  it 'should save and generate an identifier correctly' do
    lambda { @property.save! }.should change(OmLinkedData::Property, :count).by(1)
  end

  it 'should generate a Label view and return results correctly' do
    @res = @property.save
    @prop = OmLinkedData::Property.by_label(:key => @label)
    @prop[0].identifier.should == 'property_civicopenmedia_us_dcgov_method'
  end

  it 'should generate a URI for the new property' do
    @res = @property.save
    @prop = OmLinkedData::Property.find(@res["_id"])
    @res.uri.should == 'http://civicopenmedia.us/dcgov/terms#method'
  end
  
  it 'should generate an authority namespace value' do
    @res = @property.save
    @prop = OmLinkedData::Property.find(@res["_id"])
    @prop.authority == 'civicopenmedia_us_dcgov'
  end  
  
end

