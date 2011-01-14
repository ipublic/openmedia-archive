require 'spec_helper'

describe Schema::DomainsController do
  render_views

  before(:each) do
    reset_test_db!
    seed_test_db!
    @types_domain = OpenMedia::Schema::Domain.first
  end

  it 'should show list of domains' do
    get :index
    response.should be_success
    response.should render_template('index')
  end

  it 'should show info on a domain and the types inside it' do    
    get :show, :id=>@types_domain.id
    response.should be_success
    response.should render_template('show')
    assigns(:types).size.should == @types_domain.type_count
  end
end
