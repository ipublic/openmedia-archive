require 'spec_helper'

describe Schema::Namespace do

  before(:each) do
    @uri = "http://civicopenmedia.us/vocabulary/"
    @abbrev = "openmedia"
    @namespace = Schema::Namespace.new(:uri => @uri, :abbreviation => @abbrev)
  end

  it "should save and generate and identifier correctly" do
    @namespace.save!
    id = @namespace.identifier
    res = Schema::Namespace.get(id)
    res.identifier.should == "namespace_" + res.authority_uri
  end
  
end