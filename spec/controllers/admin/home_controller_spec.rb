require 'spec_helper'

describe Admin::HomeController do
  render_views

  it 'shows home page' do
    get :index
    response.should be_success
  end

  it 'shows about page' do
    get :about
    response.should be_success
  end
  
end
