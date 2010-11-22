require 'spec_helper'


describe OpenMedia::Site do

  before(:each) do
    reset_test_db!
    @org = OpenMedia::Site.new(:url=>'http://somesite.com')
  end
  
  it 'should save and generate an id correctly' do
    lambda { @org.save }.should change(OpenMedia::Site, :count).by(1)
    @org.id.should == 'http_somesite_com'
  end

end
