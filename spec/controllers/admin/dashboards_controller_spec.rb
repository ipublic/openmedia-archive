require 'spec_helper'

describe Admin::DashboardsController do
  render_views

  it 'should show dashboard page' do
    get :show
    response.should be_success
    response.should render_template('show')
  end

end
