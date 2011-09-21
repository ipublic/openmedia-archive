require 'rdf/couchdb'

class LinkedData::ShapefileParser < LinkedData::Parser
  
  # Class requires ogr2ogr executable (see: http://www.gdal.org/ogr2ogr.html)
  
  attr_accessor :output_projection
  
  # Initialization that is run when a Shapefile is imported
  # 
  # Options:
  # * <tt>:output_projection</tt>: Reproject/transform to this SRS on output (default: EPSG:4326)
  def initialize(source_file_name, options={})
    raise "Source file not found" unless File.exists?(source_file_name)
    @source_file_name = source_file_name
    @record_count = 0
    @column_count = 0

    @output_projection = options[:output_projection] unless options[:output_projection].nil?
    @output_projection ||= "EPSG:4326"
  end
  
  # Return a list of property names for this Shapefile
  def properties
    if @properties.nil?
      @properties = []
      Dir.mktmpdir do |temp_dir|
        zip_file = File.open(@source_file_name)
        `#{UNZIP} #{zip_file.path} -d #{temp_dir}`
        
        @shapefile_name = Dir.glob(File.join(temp_dir,'*.shp')).first
        raise "No .shp file found inside zip" unless File.exists?(@shapefile_name)
        @geojson_file_name = @shapefile_name.gsub(/\.shp/,'.js')
        
        # Ask the OS for ogr2ogr executable location
        ogr2ogr = %x[which ogr2ogr].strip

        # Execute ogr2ogr to convert from shapefile to geojson format
        %x!#{ogr2ogr} -t_srs #{@output_projection} -a_srs #{@output_projection} -f "GeoJSON" #{@geojson_file_name} #{@shapefile_name}!
        raise "ogr2ogr output file #{@geojson_file_name} not found" unless File.exists?(@geojson_file_name)

        File.open(@geojson_file_name) do |jsf|
          geojson = JSON.load(jsf)
          geojson['features'].first['properties'].each do |k,v|
            range = case v
                    when TrueClass, FalseClass then RDF::XSD.boolean
                    when Fixnum then RDF::XSD.integer
                    when Float then RDF::XSD.float
                    else RDF::XSD.string
                    end
                    
            # Catch situations where property name is reserved word
            k = "#{ File.basename(@shapefile_name, '.shp')}_#{k}" if k.downcase == 'model'
            @properties << LinkedData::Property.new(:term => k, :label => k.upcase, :expected_type => range.to_s)
          end
          @properties << LinkedData::Property.new(:term =>'geometry', :label => "Geometry", :expected_type => RDF::OM_CORE.GeoJson.to_s)
          @column_count = @properties.length
        end
      end
    end
    @properties
  end
  
private
  def load_records
    @properties ||= properties
    @record_count = 0
    Dir.mktmpdir do |temp_dir|
      zip_file = File.open(@source_file_name)
      `#{UNZIP} #{zip_file.path} -d #{temp_dir}`

      @shapefile_name = Dir.glob(File.join(temp_dir,'*.shp')).first
      raise "No .shp file found inside zip" unless File.exists?(@shapefile_name)
      @geojson_file_name = @shapefile_name.gsub(/\.shp/,'.js')
      
      # Ask the OS for ogr2ogr executable location
      ogr2ogr = %x[which ogr2ogr].strip

      # Execute ogr2ogr to convert from shapefile to geojson format
      %x!#{ogr2ogr} -t_srs #{@output_projection} -a_srs #{@output_projection} -f "GeoJSON" #{@geojson_file_name} #{@shapefile_name}!
      raise "ogr2ogr output file #{@geojson_file_name} not found" unless File.exists?(@geojson_file_name)

      File.open(@geojson_file_name) do |jsf|
        geojson = JSON.load(jsf)    # TODO stream this rather than load into memory all at once

        @records = []
        geojson['features'].each do |feature|
          @record_count += 1
          raw_record = LinkedData::RawRecord.new
          @properties.each {|sp| raw_record[sp.term] = feature['properties'][sp.term]}
          raw_record['geometry'] = feature['geometry']
          @records << raw_record
        end
        @records
      end
    end    
  end
  
end