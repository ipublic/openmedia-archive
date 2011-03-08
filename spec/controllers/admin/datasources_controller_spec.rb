require 'spec_helper'
require 'json'

describe Admin::DatasourcesController do
  render_views
  
  before(:all) do
    create_test_csv
    reset_test_db!
    seed_test_db!
  end
  
  after(:all) do
    delete_test_csv
  end
  
  describe 'before Site is configured' do
    it 'should redirect to new site form when uploading data' do
      get :new_upload
      response.should redirect_to(new_admin_site_path)
      flash[:error].should == ApplicationController::SITE_NOT_DEFINED_ERROR_MSG      
    end
  end

  describe 'after Site is configured' do
    before(:all) do
      @site = create_test_site
      @collection = create_test_collection(:site=>@site)
      @class = create_test_rdfs_class
      1.upto(3) {|i| ds = create_test_datasource(:title=>"Datasource #{i}", :rdfs_class_uri=>@class.uri.to_s,
                                                 :publisher_uri => RDF::URI.new('http://foo.bar/publisher'),
                                                 :creator_uri => RDF::URI.new('http://foo.bar/creator'),                                                 
                                                 :source_properties=>[{:label=>'A', :range_uri=>RDF::XSD.string},
                                                                      {:label=>'B', :range_uri=>RDF::XSD.string},
                                                                      {:label=>'C', :range_uri=>RDF::XSD.string},
                                                                      {:label=>'D', :range_uri=>RDF::XSD.string}]) }
    end

    it 'should show list of datasources' do
      get :index
      response.should be_success
      response.should render_template('index')
    end
    
    it 'should allow datasources to be deleted' do
      @datasource = OpenMedia::Datasource.first
      delete :destroy, :id=>@datasource.id
      response.should redirect_to(admin_datasources_path)
      OpenMedia::Datasource.find(@datasource.id).should be_nil
    end

    describe 'uploading data' do
      describe 'into a new datasource' do
        before(:each) do
          @datasource_params = {:title=>'New Datasource', :rdfs_class_uri=>@class.uri.to_s,
            :source_type=>OpenMedia::Datasource::TEXTFILE_TYPE,
            :parser=>OpenMedia::Datasource::DELIMITED_PARSER,
            :column_separator=>','}
        end
        
        it 'should have form to upload' do
          get :new_upload
          response.should be_success
          response.should render_template('new_upload')
        end
        
        it 'should validate datasource' do
          @datasource_params[:title] = nil
          post :upload, :datasource=>@datasource_params,
          :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
          :has_header_row=>true
          response.should be_success
          response.should render_template('new_upload')
        end
        
        it 'should create new class if existing one is not specified' do
          @datasource_params[:rdfs_class_uri] = nil          
          lambda { post :upload, :datasource=>@datasource_params, :collection_uri=>@collection.uri.to_s,
                                 :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
                                 :has_header_row=>true }.should change(OpenMedia::Schema::RDFS::Class, :count).by(1)                    
          
        end
        
        it 'should assign existing type to datasource if specified'
        
        it 'should save data file in seed_data attachment' do
          @datasource_params[:title] = 'Attachment Test'
          post :upload, :datasource=>@datasource_params,
          :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
          :has_header_row=>true
          puts assigns[:datasource].errors.inspect
          assigns[:datasource].should_not be_new_record
          assigns[:datasource].has_attachment?('seed_data').should be_true
          
        end
        
        it 'should redirect to datasource edit page to setup mapping' do
          @datasource_params[:title] = 'Redirect Test'          
          post :upload, :datasource=>@datasource_params,
          :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
          :has_header_row=>true
          
          response.should redirect_to(edit_admin_datasource_path(assigns[:datasource].id))
        end
        
        it 'should set source and datasource properties from source with all types as string' do
          @datasource_params[:title] = 'Properties Test'
          @datasource_params[:rdfs_class_uri] = nil                                        
          post :upload, :datasource=>@datasource_params, :collection_uri=>@collection.uri.to_s,
          :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
          :has_header_row=>true
          
          assigns[:datasource].rdfs_class.properties.collect{|p| p.label}.sort.should == %w(A B C D)
          assigns[:datasource].rdfs_class.properties.each{|p| p.range.should == RDF::XSD.string}
          assigns[:datasource].source_properties.collect{|p| p.label}.sort.should == %w(A B C D)
          assigns[:datasource].source_properties.each{|p| p.range_uri.should == RDF::XSD.string}
        end
        
        it 'should generate properties names when no header row is in file' do
          @datasource_params[:title] = 'Generating Properties Test'
          @datasource_params[:rdfs_class_uri] = nil                              
          post :upload, :datasource=>@datasource_params, :collection_uri=>@collection.uri.to_s,
          :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv'),
          :has_header_row=>false
          assigns[:datasource].rdfs_class.properties.collect{|p| p.label}.sort.should == %w(Column1 Column2 Column3 Column4)
          assigns[:datasource].source_properties.collect{|p| p.label}.sort.should == %w(Column1 Column2 Column3 Column4)
        end
      end
      
      describe 'into existing datasource' do
        before(:all) do
          @datasource = OpenMedia::Datasource.first
          @datasource.rdfs_class_uri = @class.uri.to_s
          @datasource.source_type = OpenMedia::Datasource::TEXTFILE_TYPE
          @datasource.parser = OpenMedia::Datasource::DELIMITED_PARSER
          @datasource.skip_lines = 1
          @datasource.column_separator = ','
          File.open('/tmp/test.csv') {|f| @datasource.create_attachment(:file=>f, :name=>'seed_data', :content_type=>'text/csv') }
          @datasource.save!          
        end
        
        it 'should handle uploads via the Import Data page' do
          original_count = @class.spira_resource.count
          lambda {
            post :upload, :datasource_id=>@datasource.id,
            :data_file=>fixture_file_upload('/tmp/test.csv', 'text/csv')
          }.should change(OpenMedia::Import, :count).by(1)
          response.should redirect_to(admin_datasources_path)
          flash[:notice].should == "Imported 2 records into datasource #{@datasource.title}"
          @class.spira_resource.count.should == original_count + 2
        end
        
        it 'should allow importing seed data' do
          @class.spira_resource.each {|r| r.destroy!}
          original_count = @class.spira_resource.count          
          lambda {
            get :import_seed_data, :id=>@datasource.id
          }.should change(OpenMedia::Import, :count).by(1)
          @datasource = OpenMedia::Datasource.get(@datasource.id)
          @datasource.has_attachment?('seed_data').should be_false        
          flash[:notice].should == "Imported 2 records into datasource #{@datasource.title}"
          @class.spira_resource.count.should == 2          
          response.should redirect_to(admin_datasource_path(@datasource))
        end
      end
    end
    
    describe 'posting new datasources' do
      before(:all) do
        @datasource_params = { :title=>'New Datasource', :rdfs_class_uri=>@class.uri.to_s,
          :source_type => OpenMedia::Datasource::TEXTFILE_TYPE,
          :parser => OpenMedia::Datasource::DELIMITED_PARSER,
          :column_separator => ',',
          :skip_lines => '1',
          :source_properties=>[{:label=>'A', :range_uri=>RDF::XSD.string},
                               {:label=>'B', :range_uri=>RDF::XSD.string},
                               {:label=>'D', :range_uri=>RDF::XSD.string}]
        }
      end
      
      it 'should have form for new datasources' do
        get :new
        response.should be_success
        response.should render_template('new')    
      end
      
      it 'should allow new datasources to be uploaded' do
        @datasource_params[:title] = 'New Datasource Test'
        lambda {
          post :create, :datasource=>@datasource_params
        }.should change(OpenMedia::Datasource, :count).by(1)
        assigns[:datasource].source_properties.size.should == 3
        assigns[:datasource].source_properties.collect{|p| p.label}.sort.should == %w(A B D)
        response.should redirect_to(admin_datasources_path)          
      end

      # JSON stuff for Refine integration not working currently
      # describe 'as json' do
      #   it 'should return a 201 on success' do
      #     post :create, :datasource=>@datasource_params, :format=>'json'
      #     response.response_code.should == 201
      #   end
      #   
      #   it 'should return a 400 with error message on error' do
      #     reset_test_db!
      #     create_test_datasource(:title=>'New Datasource')
      #     post :create, :datasource=>@datasource_params, :format=>'json'
      #     response.response_code.should == 400
      #     response.content_type.should == 'application/json'
      #     response.body.should == "Title #{OpenMedia::Datasource::TITLE_TAKEN_MSG}"
      #   end
      # end    
    end
    
    describe 'updating datasources' do
      before(:all) do
        @datasource = OpenMedia::Datasource.first
        @datasource.source_properties = [{:label=>'A', :range_uri=>RDF::XSD.string},
                                         {:label=>'B', :range_uri=>RDF::XSD.string},
                                         {:label=>'C', :range_uri=>RDF::XSD.string}]
        @datasource.save        
      end  
      
      it 'should have page for updating datasources' do
        get :edit, :id=>@datasource.id        
        response.should be_success
      end
      
      it 'should have action for adding new properties' do
        get :new_property
        response.should be_success
        response.should render_template('_datasource_property')
      end
      
      it 'should save changes to datasource' do
        put :update, :id=>@datasource.id, :datasource=>{ :metadata=>{:keywords=>"one, two, three, four"},
          :source_properties => [{:label=>'A', :range_uri=>RDF::XSD.string},
                                 {:label=>'C', :range_uri=>RDF::XSD.string}] }
        response.should redirect_to(admin_datasources_path)
        updated_datasource = OpenMedia::Datasource.get(@datasource.id)
        updated_datasource.metadata.keywords.should == %w(one two three four)
        updated_datasource.source_properties.collect{|dp| dp.label}.sort.should == %w(A C)
      end    
    end
  end
end 

