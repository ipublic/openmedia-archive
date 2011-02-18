class GeoJson::Point < GeoJson::Geometry
  
  def initialize(position)
    super
    raise ArgumentError, "Coordinates must be a GeoJson::Position type" unless position.is_a?(GeoJson::Position)

    self["type"] = GeoJson::Geometry::POINT_TYPE
    self["coordinates"] = position
  end
end