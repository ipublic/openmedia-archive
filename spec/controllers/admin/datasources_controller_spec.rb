require 'spec_helper'

describe Admin::DatasourcesController do
  render_views

  it_should_behave_like 'an admin controller'

  context 'admin logged in' do
    before(:each) do
      @site = create_test_site
      @admin = create_test_admin(@site)
      @request.host = "#{@site.identifier}.#{OM_DOMAIN}"
      sign_in :admin, @admin
    end

    it 'should show list of datasources' do
      1.upto(2) {|i| create_test_datasource(:title=>"Test Datasource #{i}") }
      get :index
      response.should be_success
      response.should render_template('index')
    end

    it 'should have form for new datasources to be created' do
      get :new
      response.should be_success
      assigns[:datasource].should_not be_nil
      response.should render_template('new')
    end

    context 'uploading' do

      context 'csv files' do
        before(:each) do
          create_test_csv
          @test_csv_file = fixture_file_upload('/tmp/test.csv', 'text/csv')
          @datasource_params = { :source_type=>OpenMedia::Datasource::TEXTFILE_TYPE,
            :parser => OpenMedia::Datasource::DELIMITED_PARSER,
            :column_separator => ',',
            :has_header_row=>'1',
          }
        end

        after(:each) do
          delete_test_csv
        end

        it 'should create new datasources when form is posted' do
          lambda { post :create,
            :textfile=>@test_csv_file,
            :datasource=>@datasource_params.merge(:title=>'A CSV Import') }.should change(OpenMedia::Datasource, :count).by(1)
          response.should redirect_to(admin_datasource_path(assigns[:datasource]))
        end

        it 'should add new datasource to site' do
          ds_count = @site.datasources.count
          post :create, :datasource=>@datasource_params.merge(:title=>'A CSV Import'), :textfile=>@test_csv_file
          @site = OpenMedia::Site.find(@site.id)
          @site.datasources.count.should == ds_count + 1
        end
      end
    end
  end
  
  
end
