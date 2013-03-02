require 'csv'

class LinkedData::CsvParser < LinkedData::Parser

  attr_accessor :header_row, :delimiter
  attr_reader :column_count, :column_types, :first_row
  
  # Initialization that is run when a Shapefile is imported
  # 
  # Options:
  # * <tt>:delimiter</tt>: character that seperates fields in a row (default: ',')
  # * <tt>:header_row</tt>: Boolean field that indicates first row in file contains property names (default: false)
  # * <tt>:header_converters</tt>: Transform header property names into symbols, replacing whitespace with underscore ('_'), etc. Use csv library settings here.  (default: "symbol").  
  def initialize(source_file_name, options={})
    super
    # configure
    
    raise "Source file not found" unless File.exists?(source_file_name)
    @source_file_name = source_file_name
    @column_count = 0
    @record_count = 0
    @column_types = []

    @delimiter = options[:delimiter] unless options[:delimiter].nil?
    @header_row = options[:header_row] unless options[:header_row].nil?
    @header_converters = options[:header_converters] unless options[:header_converters].nil?
    @converters = options[:converters] unless options[:converters].nil?

    @delimiter ||= ","
    @header_row ||= false 
    @header_converters ||= "symbol"
    @converters ||= "all"
  end
  
  def each
    Dir.glob(file).each do |file|
      
    end
  end
  
  def header_row?
    @header_row
  end
  
  # Return contents of first row in this file
  def first_row
    @first_row ||= top_rows
  end
  
  # Return a list of property names for this file
  def properties
    @first_row ||= first_row
    
    @properties = []
    # Either pull property names from first row of file or create generic names
    header_row? ? property_list = first_row : property_list = generate_property_names
    property_list.each_index do |i|
       @properties << LinkedData::Property.new(:term => property_list[i], 
                                                :expected_type => type_from_data_value(@second_row[i]))
    end
    
    @properties
  end
  
  def fields
    File.open(@source_file_name) do |input|
      fields = CSV.parse(input.readline).first
    end
  end
  
private  
  def load_records
    @properties ||= properties
    @record_count = 0
    @records = []
    
    CSV.foreach(@source_file_name, {:col_sep => @delimiter, 
                                    :header_converters => @header_converters.to_sym,
                                    :converters => @converters.to_sym }) do |row|

      raw_record = LinkedData::RawRecord.new
      @properties.each_index {|idx| raw_record[@properties[idx].term] = row[idx]}
      @records << raw_record
      @record_count += 1
    end
    @records.delete_at(0) if header_row?
    @records
  end

  def top_rows
    CSV.open(@source_file_name, {:col_sep => @delimiter}) do |csvf|
      @first_row = csvf.readline
      @second_row = csvf.readline
    end
    @column_count = @first_row.length
    @first_row
  end

  def generate_property_names
    top_rows if @column_count == 0
    property_list = []
    1.upto(@column_count) {|i| property_list << "Col_%03i"%i }
    property_list
  end  

  def configure
    source.definition.each do |options|
      case options
      when Symbol
        fields << Field.new(options)
      when Hash
        fields << Field.new(options[:name])
      else
        raise DefinitionError, "Each field definition must either be a symbol or a hash"
      end
    end
  end

  
  def validate_row(row, line, file)
    ETL::Engine.logger.debug "validating line #{line} in file #{file}"
    if row.length != fields.length
      raise_with_info( MismatchError, 
        "The number of columns from the source (#{row.length}) does not match the number of columns in the definition (#{fields.length})", 
        line, file
      )
    end
  end
  
  
end