require 'spec_helper'


describe OpenMedia::Organization do

  before(:each) do
    reset_test_db!
    @org = OpenMedia::Organization.new(:name=>'Organization 3')
  end
  
  it 'should save and generate an id correctly' do
    @org.save.should be_true
    @org.id.should == 'organization_organization_3'
  end

end
