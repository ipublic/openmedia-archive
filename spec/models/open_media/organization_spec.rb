require 'spec_helper'


describe OpenMedia::Organization do

  before(:each) do
    reset_test_db!
    @org = OpenMedia::Organization.new(:name=>'Organization 3')
  end
  
  it 'should save and generate an id correctly' do
    lambda { @org.save}.should change(OpenMedia::Organization, :count).by(1)
    @org.id.should == 'organization_organization_3'
  end

end
