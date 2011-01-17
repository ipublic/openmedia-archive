require 'spec_helper'
require 'json'

describe Admin::DatasetsController do
  render_views

  before(:all) do
    create_test_csv
  end

  after(:all) do
    delete_test_csv
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
  
  it 'should allow datasets to be deleted' do
    @dataset = OpenMedia::Dataset.first
    delete :destroy, :id=>@dataset.identifier
    response.should redirect_to(admin_datasets_path)
    OpenMedia::Dataset.find(@dataset.identifier).should be_nil
  end

  describe 'uploading data' do
    describe 'into a new dataset' do
      before(:each) do
        seed_test_db!
        @string_type = OpenMedia::Schema::Domain.default_types.find_type('string')
        @dataset_params = {:title=>'New Dataset', :catalog_id=>@catalog.identifier,
                      :source=> { :source_type=>OpenMedia::Source::FILE_TYPE,
                                  :parser=>OpenMedia::Source::DELIMITED_PARSER,
                                  :column_separator=>','}}        
      end

      it 'should validate dataset' do
        @dataset_params[:title] = nil
        post :upload, :dataset=>@dataset_params,
                      :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
                      :has_header_row=>true
        response.should be_success
        response.should render_template('new_upload')
      end

      it 'should create new type if existing one is not specified' do
        
      end

      it 'should assign existing type to dataset if specified do' do
        
      end
      
      it 'should save data file in seed_data attachment' do
        post :upload, :dataset=>@dataset_params,
                      :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
                      :has_header_row=>true
        
        assigns[:dataset].should_not be_new_record
        assigns[:dataset].has_attachment?('seed_data').should be_true
        
      end

      it 'should redirect to dataset edit page to setup mapping' do
        post :upload, :dataset=>@dataset_params,
                      :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
                      :has_header_row=>true
        
        response.should redirect_to(edit_admin_dataset_path(assigns[:dataset].identifier))
      end
      
      it 'should set source and dataset properties from source with all types as string' do
        post :upload, :dataset=>@dataset_params,
                      :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
                      :has_header_row=>true
        
        assigns[:dataset].data_type.type_properties.collect{|p| p.name}.should == %w(A B C D)
        assigns[:dataset].data_type.type_properties.each{|p| p.expected_type.should == @string_type}
        # assigns[:dataset].dataset_properties.collect{|p| p.source_name}.should == %w(A B C D)                
        assigns[:dataset].source.source_properties.collect{|p| p.name}.should == %w(A B C D)
        assigns[:dataset].source.source_properties.each{|p| p.expected_type.should == @string_type}       
      end

      it 'should generate properties names when no header row is in file' do
        post :upload, :dataset=>@dataset_params,
                      :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
                      :has_header_row=>false
        assigns[:dataset].data_type.type_properties.collect{|p| p.name}.should == %w(Column1 Column2 Column3 Column4)
        assigns[:dataset].source.source_properties.collect{|p| p.name}.should == %w(Column1 Column2 Column3 Column4)
      end
    end
    
    describe 'into existing dataset' do
      before(:each) do
        @dataset = OpenMedia::Dataset.first
        @domain = create_test_domain
        @dataset.data_type = OpenMedia::Schema::Type.new(:type_properties=>[{:name=>'A', :data_type=>@string_type},
                                                              {:name=>'B', :data_type=>@string_type},
                                                              {:name=>'D', :data_type=>@string_type}]);
        @dataset.source={ :source_type => OpenMedia::Source::FILE_TYPE,
                                       :parser => OpenMedia::Source::DELIMITED_PARSER,
                                       :column_separator => ',',
                                       :skip_lines => '1',
                                       :source_properties=>[{:name=>'A', :data_type=>@string_type},
                                                            {:name=>'B', :data_type=>@string_type},
                                                            {:name=>'C', :data_type=>@string_type},
                                                            {:name=>'D', :data_type=>@string_type}]
                          }
        File.open('/tmp/test.csv') {|f| @dataset.create_attachment(:file=>f, :name=>'seed_data', :content_type=>'text/csv') }

        @dataset.save!

      end
      
      it 'should handle uploads via the Import Data page' do
        lambda {
          post :upload, :dataset_id=>@dataset.identifier,
               :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv')
        }.should change(OpenMedia::Import, :count).by(1)
        response.should redirect_to(admin_datasets_path)
        flash[:notice].should == "Imported 2 records into dataset #{@dataset.title}"
        @dataset.model.count.should == 2
      end
      
      it 'should allow importing seed data' do
        @dataset.model.count.should == 0        
        lambda {
          get :import_seed_data, :id=>@dataset.identifier
        }.should change(OpenMedia::Import, :count).by(1)
        @dataset.model.count.should == 2
        @dataset = OpenMedia::Dataset.get(@dataset.id)
        @dataset.has_attachment?('seed_data').should be_false        
        flash[:notice].should == "Imported 2 records into dataset #{@dataset.title}"
        response.should redirect_to(admin_dataset_path(@dataset.identifier))
      end
    end
  end
  
  describe 'posting new datasets' do
    before(:each) do
      @dataset_params = { :title=>'New Dataset', :catalog_id=>@catalog.id, :unique_id_property=>'B',
                          :skip_lines=>'1', :column_separator=>',',
                          :dataset_properties=>[{:name=>'A', :data_type=>@string_type},
                                                {:name=>'B', :data_type=>@string_type},
                                                {:name=>'D', :data_type=>@string_type}],
                          :source => { :source_type => OpenMedia::Source::FILE_TYPE,
                                       :parser => OpenMedia::Source::DELIMITED_PARSER,
                                       :column_separator => ',',
                                       :skip_lines => '1',
                                       :source_properties=>[{:name=>'A', :data_type=>@string_type},
                                                            {:name=>'B', :data_type=>@string_type},
                                                            {:name=>'C', :data_type=>@string_type},
                                                            {:name=>'D', :data_type=>@string_type}]
                          }
      }
 
    end

    it 'should have form for new datasets' do
      get :new
      response.should be_success
      response.should render_template('new')    
    end
    
    it 'should allow new datasets to be uploaded' do
      lambda {
        post :create, :dataset=>@dataset_params

      }.should change(OpenMedia::Dataset, :count).by(1)
      assigns[:dataset].dataset_properties.size.should == 3
      assigns[:dataset].dataset_properties.collect{|p| p.name}.should == %w(A B D)
      assigns[:dataset].source.source_properties.size.should == 4
      assigns[:dataset].source.source_properties.collect{|p| p.name}.should == %w(A B C D)      
      response.should redirect_to(admin_datasets_path)          
    end

    describe 'as json' do
      it 'should return a 201 on success' do
        post :create, :dataset=>@dataset_params, :format=>'json'
        response.response_code.should == 201
      end

      it 'should return a 400 with error message on error' do
        reset_test_db!
        create_test_dataset(:title=>'New Dataset')
        post :create, :dataset=>@dataset_params, :format=>'json'
        response.response_code.should == 400
        response.content_type.should == 'application/json'
        response.body.should == "Title #{OpenMedia::Dataset::TITLE_TAKEN_MSG}"
      end
    end    
  end

  describe 'updating datasets' do
    before(:each) do
      @dataset = OpenMedia::Dataset.first
      @dataset.dataset_properties = [{:name=>'A', :data_type=>@string_type},
                                     {:name=>'B', :data_type=>@string_type},
                                     {:name=>'C', :data_type=>@string_type}]
      @dataset.save

      get :edit, :id=>@dataset.identifier      
    end  

    it 'should have page for updating datasets' do
      response.should be_success
    end

    it 'should have action for adding new properties' do
      get :new_property
      response.should be_success
      response.should render_template('_property')
    end

    it 'should save changes to dataset' do
      put :update, :id=>@dataset.identifier, :dataset=>{ :metadata=>{:keywords=>"one, two, three, four"},
                                                         :dataset_properties => [{:name=>'A', :data_type=>@string_type},
                                                                                 {:name=>'C', :data_type=>@string_type}] }
      response.should redirect_to(admin_datasets_path)
      updated_dataset = OpenMedia::Dataset.get(@dataset.id)
      updated_dataset.metadata.keywords.should == %w(one two three four)
      updated_dataset.dataset_properties.collect{|dp| dp.name}.should == %w(A C)
    end    
  end

end
