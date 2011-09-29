require 'spec_helper'

describe LinkedData::Topic do

  before(:each) do
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    @topic_term = "dc_addresses"
    @design_doc_id = '_design/' + @topic_term
    @topic_label = "District of Columbia Addresses"
    @instance_db_name = DB.name
    @topic = LinkedData::Topic.new(:authority => @ns.authority, 
                                    :term => @topic_term, 
                                    :label => @topic_label,
                                    :instance_database_name => @instance_db_name)
    @topic_id = "topic_civicopenmedia_us_dcgov_dc_addresses"
  end

  describe "initialization" do
    it 'should fail to initialize instance without term and authority properties' do
      @topic = LinkedData::Topic.new
      @topic.should_not be_valid
      @topic.errors[:term].should_not be_nil
      @topic.errors[:authority].should_not be_nil
      @topic.errors[:instance_topic_name].should_not be_nil
    end
    
    it 'should provide a valid CouchDB database for instances' do
      @topic.instance_database.should be_a(::CouchRest::Database)
    end
    
    it 'should save and generate an identifier correctly' do
      lambda { @topic.save! }.should_not raise_error
      saved_topic = LinkedData::Topic.by_term(:key => @topic_term)
      saved_topic.first.identifier.should == @topic_id
    end
    
    it 'should create an associated CouchRest::Design document' do
      saved_topic = LinkedData::Topic.get(@topic_id)
      dsn = saved_topic.instance_design_doc
      dsn.should be_a(::CouchRest::Design)
    end
  end
  
  describe "class methods" do
    before(:all) do
      
    end
    
    describe ".instance_design_document" do
      it "should return the Topic's CouchDB design document" do
        saved_topic = LinkedData::Topic.get(@topic_id)
        dsn = saved_topic.instance_design_doc
        dsn.name.should == @topic.term
        dsn["_id"].should == @design_doc_id
        dsn.has_view?(:all).should be_true
      end
    end

    describe ".all_instance_docs" do
      it "should return all docs for this Topic" do
      end
    end
    
    describe ".destroy_design_document" do
      it "should return the Topic's CouchDB design document" do
      end
    end
    
  end
  
  describe "instance methods" do
    # before(:each) do
    #   STAGING_DATABASE.recreate! rescue nil
    #   @csv_filename = File.join(FIXTURE_PATH, 'crime_incidents_current.csv')
    #   @parser = LinkedData::CsvParser.new(@csv_filename, {:header_row => true})
    # end
    # 
    # describe ".extract!" do
    #   it "should raise an error if DataSource doc isn't saved" do
    #     lambda{@topic.extract!(@parser.records)}.should raise_error
    #   end
    #   
    #   it "should store all parsed records in the Staging db" do
    #     @topic.save
    #     @stats = @topic.extract!(@parser.records)
    #     @stats.record_count.should == 304
    #   end
    # end
  end

  describe "views" do
    # before(:each) do
    #   STAGING_DATABASE.recreate! rescue nil
    # 
    #   @csv_ds = LinkedData::DataSource.create!(:authority => @ns.authority, :term => @topic_term)
    #   @csv_filename = File.join(FIXTURE_PATH, 'crime_incidents_current.csv')
    #   @csv_parser = LinkedData::CsvParser.new(@csv_filename, {:header_row => true})
    #   @csv_stats = @csv_ds.extract!(@csv_parser.records)
    # 
    #   @shp_ds_term = "dc_fire_stations"
    #   @shp_ds = LinkedData::DataSource.create!(:authority => @ns.authority, :term => @shp_ds_term)
    # 
    #   @shapefile_name = File.join(FIXTURE_PATH, 'FireStnPt.zip')
    #   @shp_parser = LinkedData::ShapefileParser.new(@shapefile_name)
    #   @shp_stats = @shp_ds.extract!(@shp_parser.records)
    # end
    # 
    # it "should return accurate counts for RawRecord and each DataSource" do
    #   LinkedData::DataSource.all.length.should == 2
    #   LinkedData::RawRecord.all.length.should == 339
    #   @csv_ds.raw_record_count.should == 304
    #   @csv_ds.last_extract.length.should == 304
    #   @shp_ds.raw_record_count.should == 35
    # end
    # 
  end
end