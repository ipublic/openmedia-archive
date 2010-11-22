require 'spec_helper'

describe Admin::OrganizationsController do
  render_views
  
  before(:each) do
    reset_test_db!
  end

  it 'should show list of organizations' do
    1.upto(3) {|i| OpenMedia::Organization.create!(:name=>"Org #{i}", :url=>"http://site#{i}.com")}
    get :index
    response.should be_success
    response.should render_template('index')
  end

  it 'should show details page for an organization' do
    o = OpenMedia::Organization.create!(:name=>'Org 2')
    get :show, :id=>o.id
    response.should be_success
    response.should render_template('show')
  end

  it 'should have form to create new organizations' do
    get :new
    response.should be_success
    response.should render_template('new')    
  end

  it 'should allow new organizations to be created' do
    post :create, :organization=>{ :name=> 'Test Org' }
    response.should redirect_to(admin_organization_path(assigns(:organization)))
  end

  it 'should allow organizations to be deleted' do
    o = OpenMedia::Organization.create!(:name=>'Org 2')    
    lambda { delete :destroy, :id=>o.id }.should change(OpenMedia::Organization, :count).by(-1)
    response.should redirect_to(admin_organizations_path)
  end

end
