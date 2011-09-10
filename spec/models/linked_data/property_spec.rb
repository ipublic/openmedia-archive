require 'spec_helper'

describe LinkedData::Property do

  before(:each) do
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
                                      
    @xsd = ::LinkedData::Vocabulary.create!(:base_uri => "http://www.w3.org/2001",
                                            :authority => @ns.authority,
                                            :term => "XMLSchema",
                                            :property_delimiter => "#"
                                            )
                                            
    @str_type = LinkedData::Type.create!(:vocabulary => @xsd, :term => "string", :label => "String")
  end

  it 'should properly set and get properties' do
    @comment = "Crimes are classified by type, termed as an Offense"
    @offense = LinkedData::Property.new(:term => "offense",
                                        :label => "Offense",
                                        :expected_type => @str,
                                        :comment => @comment,
                                        :deprecated => false
                                        )
                                        
    @offense.deprecated?.should == false
    @offense.comment.should == @comment
  end
   
end

