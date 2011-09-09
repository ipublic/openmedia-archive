class LinkedData::ShapefileSourceParser < LinkedData::Parser
  
  # Class requires ogr2ogr executable (see: http://www.gdal.org/ogr2ogr.html)
  
  attr_accessor :output_projection
  
  def initialize(data_resource, file, options={})
    raise "data_resource must be a LinkedData::DataResource" unless data_resource.is_a? LinkedData::DataResource
    @data_resource = data_resource
    extract_files(file)
    
    @output_projection = options["output_projection"] unless options["output_projection"].nil?
    @output_projection ||= "EPSG:4326"
  end
  
  def extract_files(zip_file)
    # Handle shapefile set passed within a single zip file
    Dir.mktmpdir do |temp_dir|
      `#{UNZIP} #{zip_file.path} -d #{temp_dir}`
      @shapefile_name = Dir.glob(File.join(temp_dir,'*.shp')).first

      raise "No .shp file found inside zip" unless @shapefile_name

      @geojson_file_name = @shapefile_name.gsub(/\.shp/,'.js')
      
      # Execute ogr2ogr in shell
      %x!#{OGR2OGR} -t_srs #{@output_projection} -a_srs #{@output_projection} -f "GeoJSON" #{@geojson_file_name} #{@shapefile_name}!
    end
  end
  
  def properties
    if @properties.nil?
      @properties = []
      File.open(@geojson_file_name) do |jsf|
        geojson = JSON.load(jsf)
        geojson['features'].first['properties'].each do |k,v|
          range = case v
                  when TrueClass, FalseClass then RDF::XSD.boolean
                  when Fixnum then RDF::XSD.integer
                  when Float then RDF::XSD.float
                  else RDF::XSD.string
                  end
          k = "#{self.title} #{k}" if k.downcase == 'type'
          @properties << LinkedData::Property.new(:term => k, :label => k.upcase, :expected_type => range.to_s)
        end
        @properties << LinkedData::Property.new(:term =>'geometry', :expected_type => RDF::OM_CORE.GeoJson.to_s)
      end
    end
    @properties
  end
  
  def parse
    rows_parsed = 0
    File.open(@geojson_file_name) do |jsf|
      geojson = JSON.load(jsf)    # TODO stream this rather than load into memory all at once

      geojson['features'].each do |feature|
        rows_parsed += 1
        raw_record = OpenMedia::RawRecord.new(:data_resource => @data_resource, :batch_serial_number => self.batch_serial_number)
        @properties.each {|sp| raw_record[sp.identifier] = feature['properties'][sp.label]}
        raw_record['geometry'] = feature['geometry']
        
        OpenMedia::RawRecord.database.bulk_save_doc(raw_record)
        OpenMedia::RawRecord.database.bulk_save if rows_parsed%500 == 0              
      end
      OpenMedia::RawRecord.database.bulk_save
    end              
  end
  
  def load!
    rows_parsed = 0
    File.open(@geojson_file_name) do |jsf|
      geojson = JSON.load(jsf)    # TODO stream this rather than load into memory all at once

      geojson['features'].each do |feature|
        rows_parsed += 1
        raw_record = OpenMedia::RawRecord.new(:data_resource => @data_resource, :batch_serial_number => self.batch_serial_number)
        @properties.each {|sp| raw_record[sp.identifier] = feature['properties'][sp.label]}
        raw_record['geometry'] = feature['geometry']
        
        OpenMedia::RawRecord.database.bulk_save_doc(raw_record)
        OpenMedia::RawRecord.database.bulk_save if rows_parsed%500 == 0              
      end
      OpenMedia::RawRecord.database.bulk_save
    end              
  end
  
end