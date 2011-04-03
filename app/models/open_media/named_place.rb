class OpenMedia::NamedPlace < Hash

  include CouchRest::Model::CastedModel    
  
  property :name
  property :state_abbreviation
  property :source
  property :source_id
  property :type
  property :description
  property :geometries, [GeoJson::Geometry]

end
