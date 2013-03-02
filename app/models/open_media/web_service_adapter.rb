class OpenMedia::WebServiceAdapter < CouchRest::Model::Base
  
  ## A simple persistance model for RestClient
  require 'rest_client'
  RestClient.log = '/tmp/om_rest_client.log'

  DELIMITED_PARSER = 'delimited'
  FIXED_WIDTH_PARSER = 'fixed_width'
  SAX_PARSER = 'sax'
  XML_PARSER = 'xml'

  PARSERS  = [SAX_PARSER, XML_PARSER]
  SUPPORTED_HTTP_METHODS = ['GET']
  SUPPORTED_FORMATS = ['JSON']
  
  use_database VOCABULARIES_DATABASE
  
  ## Property Definitions
  # General properties
  property :title
  property :method
  property :url
  property :user
  property :password
  property :headers
  property :timeout
  property :open_timeout

  property :content_type, :default => 'text/plain'
  property :params
  property :notes

  ## Future RestClient support
  # property :ssl_client_cert
  # property :ssl_client_key
  # property :ssl_ca_file
  
  timestamps!
  
  validates :title, :presence => true
  validates :method, :presence => true
  validates :url, :presence => true
  
  view_by :title
  view_by :url
  
  
  def import!
    begin
      res = RestClient.get self.url, :params => self.params
    rescue Exception => e
      raise e
    end
    
  end
  
  def request(options={})
  end


  def test_request
  end
  
  def test_connection
    res = RestClient.put 'http://rest-test.heroku.com/resource', :foo => 'baz'
    if res == "PUT http://rest-test.heroku.com/resource with a 7 byte payload, content type application/x-www-form-urlencoded {\"foo\"=>\"baz\"}" then
      true
    else
      false
    end
  end

  # response = ws_get(GEONAMES_REVERSE_GEOCODE_ADDRESS, {:params => {:lat => lat,
  #                                                      :lng => long,
  #                                                      :username => GEONAMES_USERNAME }})
  
  
  # def get(uri, headers={})
  #   begin
  #     RestClient.get(uri, headers).to_s.split(',')
  #   rescue Exception => e
  #     raise e
  #   end
  # end


end