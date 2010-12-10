class OpenMedia::Property < Hash

  STRING_TYPE = 'string'
  INTEGER_TYPE = 'integer'
  DATE_TYPE = 'date'
  DATETIME_TYPE = 'datetime'

  TYPES = [STRING_TYPE, INTEGER_TYPE, DATE_TYPE, DATETIME_TYPE]
  
  include CouchRest::Model::CastedModel

  property :name, :readonly=>true
  property :data_type
  property :display_name
  property :definition
  property :default_value
  property :example_value
  property :can_query
  property :is_key
  property :example_value
  property :comment
end

