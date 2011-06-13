require 'spec_helper'

describe OmLinkedData::Namespace do

  before(:each) do
    @url = "http://dcgov.civicopenmedia.us"
    @ns = OmLinkedData::Namespace.new(@url)
  end
  
  it 'should generate a base_uri correctly' do
    @ns.base_uri.should == "http://civicopenmedia.us/dcgov"
  end

  it 'should generate a subdomain correctly' do
    @ns.subdomain.should == "dcgov"
  end

  it 'should generate a domain correctly' do
    @ns.domain.should == "civicopenmedia.us"
  end
  
  it 'should generate an authority correctly' do
    @ns.authority.should == "civicopenmedia_us_dcgov"
  end

end
