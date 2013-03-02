class EndPoint < Hash

  include CouchRest::Model::Embeddable
  
  TEXTFILE_TYPE = 'textfile'
  SHAPEFILE_TYPE = 'shapefile'  
  DATABASE_TYPE = 'database'
  WEBSERVICE_TYPE = 'webservice'  

  TYPES = [TEXTFILE_TYPE, SHAPEFILE_TYPE]
  ADAPTOR_TYPES = %w(file_adapter database_adapter web_service_adapter)
  
  property :adaptor_type
  property :comment
  property :connection_properties # hash
  
  def ping
  end
  
end
