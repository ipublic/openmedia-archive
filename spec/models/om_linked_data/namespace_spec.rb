require 'spec_helper'

describe OmLinkedData::Namespace do

  before(:each) do
    @uri = "http://dcgov.civicopenmedia.us/"
  end

  it "should produce useful namespace properties from passed URI" do
    @ns = OmLinkedData::Namespace.new(@uri)
    @ns.subdomain.should == "dcgov"
    @ns.fqdn.should == "dcgov.civicopenmedia.us"
    @ns.authority.should == "dcgov_civicopenmedia_us"
  end
  
end