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

  it 'should have form to create a new domain' do
    get :new
    response.should be_success
    response.should render_template('new')
  end

  it 'should create new domains within the current site by default' do
    create_test_site
    post :create, :domain=>{:name=>'Foobar'}
    response.should redirect_to(schema_domains_path)
    assigns[:domain].site_id.should == OpenMedia::Site.instance.id
  end
end
