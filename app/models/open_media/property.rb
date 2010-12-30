class OpenMedia::Property < Hash

  STRING_TYPE = 'string'
  INTEGER_TYPE = 'integer'
  DATE_TYPE = 'date'
  DATETIME_TYPE = 'datetime'
  GEOMETRY_TYPE = 'geometry'

#  TYPES = [STRING_TYPE, INTEGER_TYPE, DATE_TYPE, DATETIME_TYPE]
  TYPES = [STRING_TYPE, INTEGER_TYPE, DATETIME_TYPE, GEOMETRY_TYPE]
  
  include CouchRest::Model::CastedModel

  property :name, :readonly=>true
  property :namespace
  property :data_type
  property :display_name
  property :definition
  property :default_value
  property :example_value
  property :comment
  property :source_name
  
end

