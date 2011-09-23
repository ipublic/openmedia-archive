require 'spec_helper'

describe LinkedData::DataSource do

  before(:each) do
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    @ds_term = "reported_crimes"
    @ds = LinkedData::DataSource.new(:authority => @ns.authority, :term => @ds_term)
    @ds_id = "datasource_civicopenmedia_us_dcgov_reported_crimes"
  end

  describe "initialization" do
    it 'should fail to initialize instance without term and authority properties' do
      @ds = LinkedData::DataSource.new
      @ds.should_not be_valid
      @ds.errors[:term].should_not be_nil
      @ds.errors[:authority].should_not be_nil
    end
    
    it 'should save and generate an identifier correctly' do
      lambda { LinkedData::DataSource.create!(:authority => @ns.authority, :term => @ds_term) }.should_not raise_error
      saved_dr = LinkedData::DataSource.by_term(:key => @ds_term)
      saved_dr.first.identifier.should == @ds_id
    end
  end
  
  describe "class methods" do
    describe ".serial_number" do
      it "should generate a unique serial number using MD5 hash seeded by current time and random number" do
        @sn1 = LinkedData::DataSource.serial_number
        @sn2 = LinkedData::DataSource.serial_number
        @sn1.should_not == @sn2
      end
    end
  end
  
  describe "instance methods" do
    before(:each) do
      STAGING_DATABASE.recreate! rescue nil
      @csv_filename = File.join(FIXTURE_PATH, 'crime_incidents_current.csv')
      @parser = LinkedData::CsvParser.new(@csv_filename, {:header_row => true})
    end
    
    describe ".extract!" do
      it "should raise an error if DataSource doc isn't saved" do
        lambda{@ds.extract!(@parser.records)}.should raise_error
      end
      
      it "should store all parsed records in the Staging db" do
        @ds.save
        @stats = @ds.extract!(@parser.records)
        @stats.record_count.should == 304
      end
    end
  end

  describe "views" do
    before(:each) do
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
      @csv_ds.raw_record_count.should == 304
      @csv_ds.last_extract.length.should == 304
      @shp_ds.raw_record_count.should == 35
    end

  end
end