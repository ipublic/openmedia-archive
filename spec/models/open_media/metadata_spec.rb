require 'spec_helper'

describe OpenMedia::Dataset do

  before(:each) do
    @metadata = OpenMedia::Metadata.new
  end
  
  it 'should accept keywords as a comma-separated string' do
    @metadata.keywords="one, two, three"
    @metadata.keywords.size.should == 3
  end

end