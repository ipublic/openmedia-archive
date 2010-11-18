require 'spec_helper'

describe Admin::CommunitiesController do
  render_views
  
  it 'should show the community page' do
    get :show
    response.should be_success
    response.should render_template('show')
  end
end
