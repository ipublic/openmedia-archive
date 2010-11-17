class OpenMedia::Property < Hash
  include CouchRest::Model::CastedModel

  property :name, :readonly=>true
  property :type
  property :display_name
  property :definition
  property :default_value
  property :example_value
  property :can_query
  property :is_key
  property :example_value
  property :comment
end

