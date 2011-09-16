require 'spec_helper'

describe LinkedData::Property do
  
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
  
  it 'should use "term" property to set "label" property value when not provided' do
    @prop_term = 'method'
    @property = LinkedData::Property.new(:term => @prop_term)
    @property.label.should == @prop_term
  end
   
end

