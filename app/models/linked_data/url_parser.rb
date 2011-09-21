require 'rest_client'
require 'json'

class LinkedData::UrlParser < LinkedData::Parser
  
  HTTP_GET = "get"  
  
  # Initialization that is run when a URL is accessed
  # 
  # Options:
  # * <tt>:parameters</tt>: Hash of key/value pairs to append to the HTTP get request
  # * <tt>:log_file</tt>: File name to record RestClient communication transactions (default: '/tmp/om_rest_client.log')
  def initialize(url, options={})
    @url = url
    @record_count = 0
    @column_count = 0
    
    @parameters = options[:parameters] unless options[:parameters].nil?
    @log_file = options[:log_file] unless options[:log_file].nil?
    @verb = options[:verb] unless options[:verb].nil?

    @verb ||= HTTP_GET
    @log_file ||= '/tmp/om_rest_client.log'

    RestClient.log = @log_file
  end
  
  def properties
     load_records if @properties.nil?
     @properties
  end
  
  def load_records
    begin
      request = RestClient.get(@url, :params => @parameters){|response, request, result| response }
    rescue Exception => e
      raise e
    end

    if request.headers[:content_type].include? "application/json"
      jstr = JSON.parse request.body 
      
      @properties = []
      @records = []
      jstr.each do |k,v|
        range = case v
                when TrueClass, FalseClass then RDF::XSD.boolean
                when Fixnum then RDF::XSD.integer
                when Float then RDF::XSD.float
                else RDF::XSD.string
                end
                
        @properties << LinkedData::Property.new(:term => k, :label => k.capitalize, :expected_type => range.to_s)
        
        raw_record = LinkedData::RawRecord.new
        raw_record[k] = v
        @records << raw_record        
        @record_count += 1
      end
      @column_count = @properties.length
      @records
    end
    
  end
  
end