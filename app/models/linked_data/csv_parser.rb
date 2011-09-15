require 'csv'

class LinkedData::CsvParser < LinkedData::Parser

  attr_accessor :header_row, :delimiter
  attr_reader :column_count, :column_types
  
  def initialize(source_file_name, options={})
    raise "Source file not found" unless File.exists?(source_file_name)
    @source_file_name = source_file_name
    @column_count = 0
    @column_types = []

    @delimiter = options[:delimiter] unless options[:delimiter].nil?
    @header_row = options[:header_row] unless options[:header_row].nil?
    @property_constants = options[:property_constants] unless options[:property_constants].nil?

    @delimiter ||= ","
    @header_row ||= false 
  end
  
  def header_row?
    @header_row
  end
  
  def properties
    @properties = []
    if header_row?
      property_list = first_row_values 
      1.upto(@column_count) {|i| @properties << LinkedData::Property.new(:term => property_list[i], :expected_type => @column_types[i])} 
    else
      property_list = generate_property_names
      0.upto(@column_count) {|i| @properties << LinkedData::Property.new(:term => property_list[i], :expected_type => @column_types[i])} 
    end
    
    @properties
  end
  
  def parse
    self.properties if @properties.nil?
    rows_parsed = 0
    record_set = []
    
    CSV.foreach(@source_file_name) do |row|

      # if !header_row? && rows_parsed > 0
        
      raw_record = OpenMedia::RawRecord.new
      row.each_with_index do |val, idx|
      
        val = case @properties[idx].expected_type
          when RDF::XSD.integer.to_s then val = val.to_i
          when RDF::XSD.float.to_s then val = val.to_f
          else val = val.to_s
        end        
        
        raw_record[@properties[idx].term] = val
        @property_constants.each {|k,v| raw_record[k] = v} unless @property_constants.nil?
        record_set << raw_record
      end
      rows_parsed += 1
    end
    record_set
  end

private

  def first_row_values
    CSV.open(@source_file_name, {:col_sep => @delimiter}) do |csvf|
      @first_row = csvf.readline
      @second_row = csvf.readline
    end
  
    @column_count = @first_row.length

    # infer source property types based on second data row (in case first row is header)
    @second_row.each {|val| @column_types << type_from_data_value(val)}
    @first_row
  end

  def generate_property_names
    first_row_values if @column_count == 0
    property_list = []
    1.upto(@column_count) {|i| property_list << "Col_%03i"%i }
    property_list
  end

  
  
end