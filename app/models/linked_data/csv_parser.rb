require 'csv'

class LinkedData::CsvParser < LinkedData::Parser

  attr_accessor :header_row, :delimiter
  attr_reader :column_count, :column_types, :first_row, :parsed_rows_count
  
  def initialize(source_file_name, options={})
    raise "Source file not found" unless File.exists?(source_file_name)
    @source_file_name = source_file_name
    @column_count = 0
    @parsed_rows_count = 0
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
  
  def header_row?
    @header_row
  end
  
  def first_row
    top_rows if @first_row.nil?
    @first_row
  end
  
  def properties
    first_row if @first_row.nil?
    
    @properties = []
    header_row? ? property_list = first_row : property_list = generate_property_names
    property_list.each_index do |i|
       @properties << LinkedData::Property.new(:term => property_list[i], 
                                                :expected_type => type_from_data_value(@second_row[i]))
    end
    
    @properties
  end
  
  def parse
    properties if @properties.nil?
    @parsed_rows_count = 0
    record_set = []
    
    CSV.foreach(@source_file_name, {:col_sep => @delimiter, 
                                    :header_converters => @header_converters.to_sym,
                                    :converters => @converters.to_sym }) do |row|

      raw_record = OpenMedia::RawRecord.new
      
      @properties.each_index do |idx|
        raw_record[@properties[idx].term] = row[idx]
      
        # val = case @properties[idx].expected_type
        #   when RDF::XSD.integer.to_s then val = val.to_i
        #   when RDF::XSD.float.to_s then val = val.to_f
        #   else val = val.to_s
        # end        
      end
        
      record_set << raw_record
      @parsed_rows_count += 1
    end
    record_set.delete_at(0) if header_row?
    record_set
  end

private

  def top_rows
    CSV.open(@source_file_name, {:col_sep => @delimiter}) do |csvf|
      @first_row = csvf.readline
      @second_row = csvf.readline
    end
    @column_count = @first_row.length
  end

  def generate_property_names
    top_rows if @column_count == 0
    property_list = []
    1.upto(@column_count) {|i| property_list << "Col_%03i"%i }
    property_list
  end

  
  
end