require 'spec_helper'

describe Admin::SitesController do
  render_views
  
  before(:each) do
    reset_test_db!
  end

  it 'should send you to create site settings first time you go to site page' do
    get :show
    response.should redirect_to(new_admin_site_path)
  end

  it 'should have form for new site settings' do
    get :new
    response.should be_success
    response.should render_template('new')
  end

end
