class GeoJson::MultiPoint < GeoJson::Geometry
  
  def initialize(coordinates)
    raise ArgumentError, "Coordinates must be an array of GeoJson::Position types" unless coordinates.instance_of?(Array)
    raise ArgumentError, "Coordinates must be an array of GeoJson::Position types" unless coordinates.all? { |e| e.instance_of?(GeoJson::Position) }

    write_attribute('type', GeoJson::Geometry::MULTI_POINT_TYPE)
    write_attribute('coordinates', coordinates)
  end
  
  def to_json
    Hash["type" => self.type, "coordinates" => self.coordinates]
  end

  
end