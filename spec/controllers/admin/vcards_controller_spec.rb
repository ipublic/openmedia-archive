require 'spec_helper'

describe Admin::HomeController do
  render_views

  it_should_behave_like 'an admin controller'

  context 'for a site' do

    before(:each) do
      @site = create_test_site
      @admin = create_test_admin(@site)
      @request.host = "#{@site.identifier}.#{OM_DOMAIN}"
      sign_in :admin, @admin
    end

    it 'should show collections for site on main page' do
      get :index
      response.should be_success
      response.should render_template('index')
    end

  end
  
end
