require 'digest/md5'

# Parent class for source data parsers
class LinkedData::Parser
  
  attr_reader :data_resource, :properties

  def properties
    raise "abstract method - please override"
  end
  
  def load!
    raise "abstract method - please override"
  end
  
  def batch_serial_number
    ::Digest::MD5.hexdigest(Time.now.to_i.to_s + rand.to_s).to_s
  end
  
  
end
