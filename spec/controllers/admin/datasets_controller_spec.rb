require 'spec_helper'

describe Admin::DatasetsController do
  render_views

  before(:all) do
    File.open('/tmp/test.csv', 'w') do |f|
      f.puts('A,B,C,D')
      f.puts('1,2,3,4')
      f.puts('5,6,7,8')            
    end
  end

  after(:all) do
    File.delete('/tmp/test.csv')
  end

  before(:each) do
    reset_test_db!
    @catalog = create_test_catalog
    1.upto(3) {|i| ds = create_test_dataset(:title=>"Dataset #{i}", :catalog=>@catalog) }
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
    response.should redirect_to(upload_admin_dataset_url(assigns[:dataset].identifier))
  end

  it 'should have form for uploading sample data' do
    ds = create_test_dataset(:catalog=>@catalog)
    get :upload, :id=>ds.identifier
    response.should be_success
    response.should render_template('upload')
  end

  it 'should allow sample data upload' do
    ds = create_test_dataset(:catalog=>@catalog)

    put :upload_file, :id=>ds.identifier, :dataset=>{ :delimiter_character=>',', :has_header_row=>'1' },
                      :uploaded_file=>fixture_file_upload('/tmp/test.csv', 'text/csv')
    assigns[:dataset].dataset_properties.size.should == 4
    response.should redirect_to(new_import_admin_dataset_path(ds.identifier))
  end

  it 'should allow properties to be reviewed before importing' do
    ds = create_test_dataset(:catalog=>@catalog)
    File.open('/tmp/test.csv') do |f|
      ds.initialize_properties!(f)
    end
    get :new_import, :id=>ds.identifier
    response.should be_success
    response.should render_template('import')
  end

  it 'accept selected property names and import sample data' do
    ds = create_test_dataset(:catalog=>@catalog)
    File.open('/tmp/test.csv') do |f|
      ds.initialize_properties!(f)
    end
    put :import, :id=>ds.identifier, :dataset=>{:unique_id_property=>'B'}
    response.should redirect_to(admin_datasets_path)
  end



end
