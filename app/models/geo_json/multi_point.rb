class GeoJson::MultiPoint < GeoJson::Geometry
  
  def initialize(positions)
    super
    raise ArgumentError, 
      "Coordinates must be an array of GeoJson::Position types" unless positions.is_a?(Array)
    raise ArgumentError,
      "Coordinates must be an array of GeoJson::Position types" unless positions.all? { |e| e.is_a?(GeoJson::Position) }
    
    self["type"] = GeoJson::Geometry::MULTI_POINT_TYPE
    self["coordinates"] = positions
  end
  
end