require 'spec_helper'

describe Admin::DatasetsController do
  render_views

  before(:each) do
    reset_test_db!
    @catalog = OpenMedia::Catalog.create!(:title=>'Test Catalog', :metadata => { })
    1.upto(3) {|i| ds = OpenMedia::Dataset.new(:title=>"Dataset #{i}"); ds.catalog_ids=[@catalog.id]; ds.save! }
  end
  
  it 'should show list of datasets' do
    get :index
    response.should be_success
    response.should render_template('index')
  end
  
  it 'should have form for new datasets' do
    get :new
    response.should be_success
    response.should render_template('new')    
  end

  it 'should allow new datasets to be uploaded' do
    lambda { post :create, :dataset=>{ :title=>'New Dataset', :catalog_ids=>[@catalog.id]} }.should change(OpenMedia::Dataset, :count).by(1)
    response.should redirect_to(upload_admin_dataset_url(assigns[:dataset].class_name))
  end

  it 'should '

end
