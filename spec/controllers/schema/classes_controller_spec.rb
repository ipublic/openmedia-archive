require 'spec_helper'

describe Schema::ClassesController do

  before(:each) do
    reset_test_db!
    seed_test_db!    
    @site = create_test_site
    @class = OpenMedia::Schema::RDFS::Class.create_in_site!(@site, :label=>'Date Test')
  end
  
  it 'should provide json autocompletion for class and datatype names' do    
    get :autocomplete, :term=>'date'
    response.should be_success
    json = JSON.parse(response.body)
    json.size.should == 3
  end

end
