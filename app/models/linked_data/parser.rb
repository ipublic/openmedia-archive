# Parent class for source data parsers
class LinkedData::Parser
  include Enumerable
  
  class << self
    def class_for_name(name)
      LinkedData::Parser.const_get("#{name.to_s.camelize}Parser")
    end
  end
  
  INTEGER_REGEX = /^[-+]?\d+([,]\d+)*$/
  FLOAT_REGEX = /[-+]?[0-9]*\.[0-9]+/
  TWENTY_FOUR_HOUR_TIME_REGEX = /^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/
  TWELVE_HOUR_TIME_REGEX = /^([1-9]|1[0-2]|0[1-9]){1}(:[0-5][0-9]){2}([aApP][mM]){1}$/
  CSV_DATE_REGEX = / \A(?: (\w+,?\s+)?\w+\s+\d{1,2},?\s+\d{2,4} | \d{4}-\d{2}-\d{2} )\z /x
  US_DATE_REGEX = /^(([1-9])|(0[1-9])|(1[0-2]))\/(([1-9])|(0[1-9])|(1[0-9])|(2[0-9])|(3[0-1]))\/((\d{2})|(\d{4}))$/
  DATE_TIME_REGEX = /^([0]\d|[1][0-2])\/([0-2]\d|[3][0-1])\/([2][01]|[1][6-9])\d{2}(\s([0]\d|[1][0-2])(\:[0-5]\d){1,2})*\s*([aApP][mM]{0,2})?$/
  # FLEX_DATE_TIME_REGEX = /^(([1-9])|(0[1-9])|(1[0-2]))\/(([1-9])|(0[1-9])|(1[0-9])|(2[0-9])|(3[0-1]))\/((\d{2})|(\d{4}))([1-9]|1[0-2]|0[1-9]){2}(:[0-5][0-9][aApP][mM]){1}$/
  CSV_DATE_TIME_REGEX = / \A(?: (\w+,?\s+)?\w+\s+\d{1,2}\s+\d{1,2}:\d{1,2}:\d{1,2},?\s+\d{2,4} | \d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2} )\z /x
  BOOLEAN_REGEX = /^(true)|(false)$/i
  
  attr_reader :data_resource, :source_file_name, :properties, :record_count, :column_count, :records

  def properties
    raise "abstract method - please override"
  end
  
  # Return a list of key/value pairs for this data source
  def records
    @records ||= load_records
  end
  
  def load_records
    raise "abstract method - please override"
  end
  
  def type_from_data_value(data)
    value = data.to_s
    if value =~ FLOAT_REGEX
      type_uri = RDF::XSD.float.to_s      
    elsif value =~ INTEGER_REGEX
      type_uri = RDF::XSD.integer.to_s
    elsif value =~ TWENTY_FOUR_HOUR_TIME_REGEX
      type_uri = RDF::XSD.time.to_s      
    elsif value =~ TWELVE_HOUR_TIME_REGEX
      type_uri = RDF::XSD.time.to_s      
    elsif value =~ CSV_DATE_REGEX
      type_uri = RDF::XSD.date.to_s      
    elsif value =~ US_DATE_REGEX
      type_uri = RDF::XSD.date.to_s      
    elsif value =~ CSV_DATE_TIME_REGEX
      type_uri = RDF::XSD.dateTime.to_s      
    elsif value =~ DATE_TIME_REGEX
      type_uri = RDF::XSD.dateTime.to_s      
    elsif value =~ BOOLEAN_REGEX
      type_uri = RDF::XSD.boolean.to_s      
    else
      type_uri = RDF::XSD.string.to_s      
    end
    type_uri
  end
  
end
