require 'spec_helper'

describe LinkedData::DataSource do

  before(:all) do
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    @ds_term = "reported_crimes"
    @ds = LinkedData::DataSource.new(:authority => @ns.authority, :term => @ds_term)
    @ds_id = "datasource_reported_crimes"

    # STAGING_DATABASE.recreate! rescue nil
    @csv_filename = File.join(FIXTURE_PATH, 'crime_incidents_current.csv')
    @parser = LinkedData::CsvParser.new(@csv_filename, {:header_row => true})
  end

  describe "initialization" do
    it 'should fail to initialize instance without term and authority properties' do
      @ds = LinkedData::DataSource.new
      @ds.should_not be_valid
      @ds.errors[:term].should_not be_nil
      @ds.errors[:authority].should_not be_nil
    end

    it "should accept an array of LinkedData::Property for source data" do
      @ds.properties = @parser.properties
      @ds.properties.length.should == 22
      @ds.properties.first.should be_a(LinkedData::Property)
      @ds.properties.first.term.should == "NID"
    end
    
    it 'should save and generate an identifier correctly' do
      lambda { LinkedData::DataSource.create!(:authority => @ns.authority, :term => @ds_term) }.should_not raise_error
      saved_ds = LinkedData::DataSource.get @ds_id
      saved_ds.identifier.should == @ds_id
    end

    it 'should present a LinkedData::DataSource when searching by key' do
      saved_ds = LinkedData::DataSource.by_term(:key => @ds_term)
      saved_ds.first.identifier.should == @ds_id
    end
  end
  
  describe "class methods" do
    describe ".serial_number" do
      it "should generate a unique serial number using MD5 hash seeded by current time and random number" do
        LinkedData::DataSource.serial_number.should_not == LinkedData::DataSource.serial_number
      end
    end
  end
  
  describe "instance methods" do
    describe ".extract!" do
      it "should raise an error if DataSource doc isn't saved" do
        lambda{@ds.extract!(@parser.records)}.should raise_error
      end

      it "should store all parsed records in the Staging db" do
        # @ds.save
        saved_ds = LinkedData::DataSource.get @ds_id
        @stats = saved_ds.extract!(@parser.records)
        @stats.docs_written.should == 304
      end
    end
  end

  describe "views" do
    before(:all) do
      STAGING_DATABASE.recreate! rescue nil

      @csv_ds = LinkedData::DataSource.create!(:authority => @ns.authority, :term => @ds_term)
      @csv_filename = File.join(FIXTURE_PATH, 'crime_incidents_current.csv')
      @csv_parser = LinkedData::CsvParser.new(@csv_filename, {:header_row => true})
      @csv_stats = @csv_ds.extract!(@csv_parser.records)

      @shp_ds_term = "dc_fire_stations"
      @shp_ds = LinkedData::DataSource.create!(:authority => @ns.authority, :term => @shp_ds_term)

      @shapefile_name = File.join(FIXTURE_PATH, 'FireStnPt.zip')
      @shp_parser = LinkedData::ShapefileParser.new(@shapefile_name)
      @shp_stats = @shp_ds.extract!(@shp_parser.records)
    end

    it "should return accurate counts for RawRecord and each DataSource" do
      LinkedData::DataSource.all.length.should == 2
      LinkedData::RawRecord.all.length.should == 339
      @csv_ds.raw_doc_count.should == 304
      @csv_ds.last_extract.length.should == 304
      @shp_ds.raw_doc_count.should == 35
    end

  end
end