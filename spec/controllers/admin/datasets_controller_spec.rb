require 'spec_helper'
require 'json'

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

  it 'should have action for uploading sample data and getting back properties html' do
    post :extract_seed_properties, :column_separator=>',', :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv')
    assigns[:properties].size.should == 4
    response.should be_success
    response.should render_template('extract_seed')
  end

  it 'should allow datasets to be deleted' do
    @dataset = OpenMedia::Dataset.first
    delete :destroy, :id=>@dataset.identifier
    response.should redirect_to(admin_datasets_path)
    OpenMedia::Dataset.find(@dataset.identifier).should be_nil
  end
  
  describe 'posting new datasets' do
    before(:each) do
      @dataset_params = { :title=>'New Dataset', :catalog_id=>@catalog.id, :unique_id_property=>'B',
                          :skip_lines=>'1', :column_separator=>',',
                          :dataset_properties=>[{:name=>'A', :data_type=>OpenMedia::Property::STRING_TYPE},
                                                {:name=>'B', :data_type=>OpenMedia::Property::STRING_TYPE},
                                                {:name=>'D', :data_type=>OpenMedia::Property::STRING_TYPE}],
                          :source => { :source_type => OpenMedia::Source::FILE_TYPE,
                                       :parser => OpenMedia::Source::DELIMITED_PARSER,
                                       :column_separator => ',',
                                       :skip_lines => '1',
                                       :source_properties=>[{:name=>'A', :data_type=>OpenMedia::Property::STRING_TYPE},
                                                            {:name=>'B', :data_type=>OpenMedia::Property::STRING_TYPE},
                                                            {:name=>'C', :data_type=>OpenMedia::Property::STRING_TYPE},
                                                            {:name=>'D', :data_type=>OpenMedia::Property::STRING_TYPE}]
                          }
      }
 
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
      @dataset.dataset_properties = [{:name=>'A', :data_type=>OpenMedia::Property::STRING_TYPE},
                                     {:name=>'B', :data_type=>OpenMedia::Property::STRING_TYPE},
                                     {:name=>'C', :data_type=>OpenMedia::Property::STRING_TYPE}]
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
                                                         :dataset_properties => [{:name=>'A', :data_type=>OpenMedia::Property::STRING_TYPE},
                                                                                 {:name=>'C', :data_type=>OpenMedia::Property::STRING_TYPE}] }
      response.should redirect_to(admin_datasets_path)
      updated_dataset = OpenMedia::Dataset.get(@dataset.id)
      updated_dataset.metadata.keywords.should == %w(one two three four)
      updated_dataset.dataset_properties.collect{|dp| dp.name}.should == %w(A C)
    end    
  end

end
