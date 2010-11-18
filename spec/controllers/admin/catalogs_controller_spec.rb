require 'spec_helper'

describe Admin::CatalogsController do
  render_views

  before(:each) do
    reset_test_db!
    1.upto(3) {|i| OpenMedia::Catalog.create!(:title=>"Catalog #{i}", :metadata =>{ }) }
  end
  
  it 'should show list of catalogs' do
    get :index
    response.should be_success
    response.should render_template('index')    
  end

  it 'should show details of a catalog' do
    c = OpenMedia::Catalog.create!(:title=>'Test Catalog', :metadata=>{ })
    get :show, :id=>c.id
    response.should be_success
    response.should render_template('show')        
  end

  it 'should allow catalog deletion' do
    c = OpenMedia::Catalog.create!(:title=>'Test Catalog', :metadata=>{ })
    delete :destroy, :id=>c.id
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
