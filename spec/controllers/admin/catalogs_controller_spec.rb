require 'spec_helper'

describe Admin::CatalogsController do
  render_views

  before(:each) do
    reset_test_db!
    @catalogs = []
    1.upto(3) {|i| @catalogs << create_test_catalog(:title=>"Catalog #{i}") }
  end
  
  it 'should show list of catalogs' do
    get :index
    response.should be_success
    response.should render_template('index')    
  end

  it 'should show details of a catalog' do
    get :show, :id=>@catalogs[0].id
    response.should be_success
    response.should render_template('show')        
  end

  it 'should allow catalog deletion' do
    delete :destroy, :id=>@catalogs[0].id
    response.should redirect_to(admin_catalogs_path)
  end
  

  it 'should have form for new catalogs' do
    get :new
    response.should be_success
    response.should render_template('new')        
  end

  it 'should allow submitting new catalogs' do
    post :create, :catalog => { :title=>'New Catalog', :metadata=>{ }}
    response.should be_redirect
  end
end
