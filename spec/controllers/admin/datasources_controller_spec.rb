require 'spec_helper'
require 'json'

describe Admin::DatasourcesController do
  # TODO - REIMPLEMENT!
  # render_views
  # 
  # before(:all) do
  #   create_test_csv
  # end
  # 
  # after(:all) do
  #   delete_test_csv
  # end
  # 
  # before(:each) do
  #   reset_test_db!    
  # end
  # 
  # describe 'before Site is configured' do
  #   it 'should redirect to new site form when uploading data' do
  #     get :new_upload
  #     response.should redirect_to(new_admin_site_path)
  #     flash[:error].should == ApplicationController::SITE_NOT_DEFINED_ERROR_MSG      
  #   end
  # end
  # 
  # describe 'after Site is configured' do
  #   before(:each) do
  #     @site = create_test_site
  #     @domain = create_test_domain(:site=>@site)
  #     @type = create_test_type(:domain=>@domain)
  #     1.upto(3) {|i| ds = create_test_datasource(:title=>"Datasource #{i}", :data_type=>@type) }      
  #   end
  # 
  #   it 'should show list of datasources' do
  #     get :index
  #     response.should be_success
  #     response.should render_template('index')
  #   end
  #   
  #   it 'should allow datasources to be deleted' do
  #     @datasource = OpenMedia::Datasource.first
  #     delete :destroy, :id=>@datasource.identifier
  #     response.should redirect_to(admin_datasources_path)
  #     OpenMedia::Datasource.find(@datasource.identifier).should be_nil
  #   end
  # 
  #   describe 'uploading data' do
  #     describe 'into a new datasource' do
  #       before(:each) do
  #         seed_test_db!
  #         @string_type = OpenMedia::Schema::Domain.default_types.find_type('string')
  #         @datasource_params = {:title=>'New Datasource', :data_type_id=>@type.id,
  #           :source=> { :source_type=>OpenMedia::Source::FILE_TYPE,
  #             :parser=>OpenMedia::Source::DELIMITED_PARSER,
  #             :column_separator=>','}}        
  #       end
  # 
  #       it 'should have form to upload' do
  #         get :new_upload
  #         response.should be_success
  #         response.should render_template('new_upload')
  #       end
  # 
  #       it 'should validate datasource' do
  #         @datasource_params[:title] = nil
  #         post :upload, :datasource=>@datasource_params,
  #         :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
  #         :has_header_row=>true
  #         response.should be_success
  #         response.should render_template('new_upload')
  #       end
  # 
  #       it 'should create new type if existing one is not specified' do
  #         @datasource_params[:domain_id] = @domain.id
  #         lambda { post :upload, :datasource=>@datasource_params, :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
  #           :has_header_row=>true }.should change(@domain.types, :size).by(1)                    
  #         
  #       end
  # 
  #       it 'should assign existing type to datasource if specified do'
  #       
  #       it 'should save data file in seed_data attachment' do
  #         post :upload, :datasource=>@datasource_params,
  #         :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
  #         :has_header_row=>true
  #         
  #         assigns[:datasource].should_not be_new_record
  #         assigns[:datasource].has_attachment?('seed_data').should be_true
  #         
  #       end
  # 
  #       it 'should redirect to datasource edit page to setup mapping' do
  #         post :upload, :datasource=>@datasource_params,
  #         :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
  #         :has_header_row=>true
  #         
  #         response.should redirect_to(edit_admin_datasource_path(assigns[:datasource].identifier))
  #       end
  #       
  #       it 'should set source and datasource properties from source with all types as string' do
  #         post :upload, :datasource=>@datasource_params,
  #         :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
  #         :has_header_row=>true
  #         
  #         assigns[:datasource].data_type.type_properties.collect{|p| p.name}.should == %w(A B C D)
  #         assigns[:datasource].data_type.type_properties.each{|p| p.expected_type.should == @string_type}
  #         # assigns[:datasource].datasource_properties.collect{|p| p.source_name}.should == %w(A B C D)                
  #         assigns[:datasource].source.source_properties.collect{|p| p.name}.should == %w(A B C D)
  #         assigns[:datasource].source.source_properties.each{|p| p.expected_type.should == @string_type}       
  #       end
  # 
  #       it 'should generate properties names when no header row is in file' do
  #         post :upload, :datasource=>@datasource_params,
  #         :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
  #         :has_header_row=>false
  #         assigns[:datasource].data_type.type_properties.collect{|p| p.name}.should == %w(Column1 Column2 Column3 Column4)
  #         assigns[:datasource].source.source_properties.collect{|p| p.name}.should == %w(Column1 Column2 Column3 Column4)
  #       end
  #     end
  #     
  #     describe 'into existing datasource' do
  #       before(:each) do
  #         @datasource = OpenMedia::Datasource.first
  #         @domain = create_test_domain
  #         @datasource.data_type = OpenMedia::Schema::Type.new(:type_properties=>[{:name=>'A', :data_type=>@string_type},
  #                                                                             {:name=>'B', :data_type=>@string_type},
  #                                                                             {:name=>'D', :data_type=>@string_type}]);
  #         @datasource.source={ :source_type => OpenMedia::Source::FILE_TYPE,
  #           :parser => OpenMedia::Source::DELIMITED_PARSER,
  #           :column_separator => ',',
  #           :skip_lines => '1',
  #           :source_properties=>[{:name=>'A', :data_type=>@string_type},
  #                                {:name=>'B', :data_type=>@string_type},
  #                                {:name=>'C', :data_type=>@string_type},
  #                                {:name=>'D', :data_type=>@string_type}]
  #         }
  #         File.open('/tmp/test.csv') {|f| @datasource.create_attachment(:file=>f, :name=>'seed_data', :content_type=>'text/csv') }
  # 
  #         @datasource.save!
  # 
  #       end
  #       
  #       it 'should handle uploads via the Import Data page' do
  #         lambda {
  #           post :upload, :datasource_id=>@datasource.identifier,
  #           :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv')
  #         }.should change(OpenMedia::Import, :count).by(1)
  #         response.should redirect_to(admin_datasources_path)
  #         flash[:notice].should == "Imported 2 records into datasource #{@datasource.title}"
  #         @datasource.model.count.should == 2
  #       end
  #       
  #       it 'should allow importing seed data' do
  #         @datasource.model.count.should == 0        
  #         lambda {
  #           get :import_seed_data, :id=>@datasource.identifier
  #         }.should change(OpenMedia::Import, :count).by(1)
  #         @datasource.model.count.should == 2
  #         @datasource = OpenMedia::Datasource.get(@datasource.id)
  #         @datasource.has_attachment?('seed_data').should be_false        
  #         flash[:notice].should == "Imported 2 records into datasource #{@datasource.title}"
  #         response.should redirect_to(admin_datasource_path(@datasource.identifier))
  #       end
  #     end
  #   end
  #   
  #   describe 'posting new datasources' do
  #     before(:each) do
  #       @datasource_params = { :title=>'New Datasource', :data_type_id=>@type.id, :unique_id_property=>'B',
  #         :skip_lines=>'1', :column_separator=>',',
  #         :datasource_properties=>[{:name=>'A', :data_type=>@string_type},
  #                               {:name=>'B', :data_type=>@string_type},
  #                               {:name=>'D', :data_type=>@string_type}],
  #         :source => { :source_type => OpenMedia::Source::FILE_TYPE,
  #           :parser => OpenMedia::Source::DELIMITED_PARSER,
  #           :column_separator => ',',
  #           :skip_lines => '1',
  #           :source_properties=>[{:name=>'A', :data_type=>@string_type},
  #                                {:name=>'B', :data_type=>@string_type},
  #                                {:name=>'C', :data_type=>@string_type},
  #                                {:name=>'D', :data_type=>@string_type}]
  #         }
  #       }
  #       
  #     end
  # 
  #     it 'should have form for new datasources' do
  #       get :new
  #       response.should be_success
  #       response.should render_template('new')    
  #     end
  #     
  #     it 'should allow new datasources to be uploaded' do
  #       lambda {
  #         post :create, :datasource=>@datasource_params
  # 
  #       }.should change(OpenMedia::Datasource, :count).by(1)
  #       assigns[:datasource].datasource_properties.size.should == 3
  #       assigns[:datasource].datasource_properties.collect{|p| p.name}.should == %w(A B D)
  #       assigns[:datasource].source.source_properties.size.should == 4
  #       assigns[:datasource].source.source_properties.collect{|p| p.name}.should == %w(A B C D)      
  #       response.should redirect_to(admin_datasources_path)          
  #     end
  # 
  #     describe 'as json' do
  #       it 'should return a 201 on success' do
  #         post :create, :datasource=>@datasource_params, :format=>'json'
  #         response.response_code.should == 201
  #       end
  # 
  #       it 'should return a 400 with error message on error' do
  #         reset_test_db!
  #         create_test_datasource(:title=>'New Datasource')
  #         post :create, :datasource=>@datasource_params, :format=>'json'
  #         response.response_code.should == 400
  #         response.content_type.should == 'application/json'
  #         response.body.should == "Title #{OpenMedia::Datasource::TITLE_TAKEN_MSG}"
  #       end
  #     end    
  #   end
  # 
  #   describe 'updating datasources' do
  #     before(:each) do
  #       @datasource = OpenMedia::Datasource.first
  #       @datasource.datasource_properties = [{:name=>'A', :data_type=>@string_type},
  #                                      {:name=>'B', :data_type=>@string_type},
  #                                      {:name=>'C', :data_type=>@string_type}]
  #       @datasource.save
  # 
  #       get :edit, :id=>@datasource.identifier      
  #     end  
  # 
  #     it 'should have page for updating datasources' do
  #       response.should be_success
  #     end
  # 
  #     it 'should have action for adding new properties' do
  #       get :new_property
  #       response.should be_success
  #       response.should render_template('_property')
  #     end
  # 
  #     it 'should save changes to datasource' do
  #       put :update, :id=>@datasource.identifier, :datasource=>{ :metadata=>{:keywords=>"one, two, three, four"},
  #         :datasource_properties => [{:name=>'A', :data_type=>@string_type},
  #                                 {:name=>'C', :data_type=>@string_type}] }
  #       response.should redirect_to(admin_datasources_path)
  #       updated_datasource = OpenMedia::Datasource.get(@datasource.id)
  #       updated_datasource.metadata.keywords.should == %w(one two three four)
  #       updated_datasource.datasource_properties.collect{|dp| dp.name}.should == %w(A C)
  #     end    
  #   end
  #   
  # end 
end
