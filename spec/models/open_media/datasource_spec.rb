require 'spec_helper'

describe OpenMedia::Datasource do

  it 'should require title, parser, and source_type' do
    @ds = OpenMedia::Datasource.new
    @ds.should_not be_valid
    @ds.errors[:title].should_not be_nil
    @ds.errors[:parser].should_not be_nil
    @ds.errors[:source_type].should_not be_nil    
  end

  context 'datasource import from csv file' do
    before(:each) do
      @datasource = create_test_datasource(:column_separator=>',', :has_header_row=>'1')
      @datasource.initial_import!(File.open(test_csv_path))
    end
    
    it 'should create columns from seed data file and detect integer and float data types' do      
      @datasource.source_properties.collect {|p| p.label}.should == %w(A B C D E)
      @datasource.source_properties.collect {|p| p.range_uri}.should == [RDF::XSD.string.to_s, RDF::XSD.integer.to_s, RDF::XSD.integer.to_s, RDF::XSD.float.to_s, RDF::XSD.float.to_s]
    end

    it 'should load raw records into staging database' do
      @datasource.raw_records.size.should == 2      
      @datasource.raw_record_count.should == 2
      @datasource.raw_records.all? {|rr| rr.datasource_id.should == @datasource.id}
      @datasource.raw_records.all? {|rr| rr.created_at.should_not be_nil}      
    end

    it 'should name columns automatically when no header row in csv' do
      @datasource = create_test_datasource(:column_separator=>',', :has_header_row=>'0')
      @datasource.initial_import!(File.open(test_csv_path))
      @datasource.source_properties.collect {|p| p.label}.should == %w(Column001 Column002 Column003 Column004 Column005)
    end

    it 'should cast incoming data to source_property type' do
      @datasource.raw_records.first['a'].class.should == String
      @datasource.raw_records.first['b'].class.should == Fixnum
      @datasource.raw_records.first['c'].class.should == Fixnum
      @datasource.raw_records.first['d'].class.should == Float
      @datasource.raw_records.first['e'].class.should == Float      
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

  # context 'publishing' do
  #   context 'valid_for_publishing?' do
  #     before(:each) do
  #       @datasource = create_test_datasource(:column_separator=>',', :has_header_row=>'1')
  #       @datasource.initial_import!(File.open(test_csv_path))
  #       OpenMedia::Site.first.initialize_metadata
  #     end
  #     
  #     it 'should require description, rdfs_class_uri, creator_uri, and publisher_uri' do
  #       @datasource.should_not be_valid_for_publishing
  #       @datasource.rdfs_class_uri = create_test_rdfs_class(:site=>OpenMedia::Site.first).uri.to_s
  #       @datasource.metadata = {:description => 'blah blah blah',
  #         :creator_uri => OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.each.first.uri.to_s,          
  #         :publisher_uri => OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.each.first.uri.to_s
  #       }
  #       @datasource.should be_valid_for_publishing
  #     end
  #   end
  # end

end
