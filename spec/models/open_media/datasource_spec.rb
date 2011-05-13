require 'spec_helper'

describe OpenMedia::Datasource do

  it 'should require title, parser, and source_type' do
    @ds = OpenMedia::Datasource.new
    @ds.should_not be_valid
    @ds.errors[:title].should_not be_nil
    @ds.errors[:parser].should_not be_nil
    @ds.errors[:source_type].should_not be_nil    
  end

  context 'dataset import from csv file' do
    before(:each) do
      @datasource = create_test_datasource(:column_separator=>',', :has_header_row=>'1')
      @datasource.initial_import!(File.open(test_csv_path))
    end
    
    it 'should create columns from seed data file' do      
      @datasource.source_properties.collect {|p| p.label}.should == %w(A B C D)
    end

    it 'should load raw records into staging database' do
      @datasource.raw_records.size.should == 2
      @datasource.raw_record_count.should == 2
    end
  end

  context 'dataset import from shapefile' do
    before(:each) do
      @datasource = create_test_datasource(:source_type=>OpenMedia::Datasource::SHAPEFILE_TYPE)
      @datasource.initial_import!(File.open(test_shapefile_path))
    end

    it 'should create columns from properties in shapefile' do      
      @datasource.source_properties.size.should == 15
      @datasource.source_properties.last.label.should == 'geometry'
    end    

    it 'should load raw records into staging database' do
      @datasource.raw_records.size.should == 2
      @datasource.raw_record_count.should == 2      
    end
  end

end
