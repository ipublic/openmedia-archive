require 'digest/md5'

# Parent class for source data parsers
class LinkedData::Parser
  
  attr_accessor :property_constants
  attr_reader :data_resource, :source_file_name, :properties

  def properties
    raise "abstract method - please override"
  end
  
  def parse
    raise "abstract method - please override"
  end
  
end
