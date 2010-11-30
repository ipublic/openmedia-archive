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

  it 'should have action for uploading sample data and getting back properties and upto 10 rows of sample data' do
    post :upload, :has_header_row=>'1', :delimiter_character=>',', :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv')
    response.should be_success
    response.content_type.should == 'application/json'
    response_json = JSON.parse(response.body)
    response_json['properties'].should == %w(A B C D)
    response_json['rows'].should == [['1','2','3','4'], ['5','6','7','8']]
  end  

  it 'should allow new datasets to be uploaded' do
    lambda {
      post :create, :dataset=>{ :title=>'New Dataset', :catalog_ids=>[@catalog.id], :unique_id_property=>'B',
                                :has_header_row=>'1', :delimiter_character=>',',
                                :dataset_properties=>[{:name=>'A', :data_type=>OpenMedia::Property::STRING_TYPE},
                                                      {:name=>'B', :data_type=>OpenMedia::Property::STRING_TYPE},
                                                      {:name=>'D', :data_type=>OpenMedia::Property::STRING_TYPE}],
                                :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv') }

    }.should change(OpenMedia::Dataset, :count).by(1)
    assigns[:dataset].dataset_properties.size.should == 3
    assigns[:dataset].dataset_properties.collect{|p| p.name}.should == %w(A B D)
    assigns[:dataset].model.count.should == 2
    response.should redirect_to(admin_datasets_path)    
  end

  it 'should redirect when format is html, and return a 201 when format is json'


end
