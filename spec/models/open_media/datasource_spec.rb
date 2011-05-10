require 'spec_helper'

describe OpenMedia::Datasource do

  it 'should require title, parser, and source_type' do
    @ds = OpenMedia::Datasource.new
    @ds.should_not be_valid
    @ds.errors[:title].should_not be_nil
    @ds.errors[:parser].should_not be_nil
    @ds.errors[:source_type].should_not be_nil    
  end

  context 'dataset definition' do
    before(:each) do
      create_test_csv
      @datasource = create_test_datasource(:column_separator=>',', :has_header_row=>'1')
      @datasource.initial_import!(File.open('/tmp/test.csv'))
    end
    
    it 'should create columns from seed data file' do      
      @datasource.source_properties.collect {|p| p.label}.should == %w(A B C D)
    end

    it 'should load raw records into staging database' do
      @datasource.raw_records.size.should == 2
      @datasource.raw_record_count.should == 2
    end
  end

end
