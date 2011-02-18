class GeoJson::Geometry < Hash

  # Based on GeoJSON Geometry Objects: http://geojson.org/geojson-spec.html
  
  # Position: array of numbers with at least two elements, e.g.; [x, y] or [x, y, z].  Position values are stored in the 'coordinates' property
  #   coordinate order: [easting, northing, altitude]
  #   geographic order: [longitude, latitude, altitude]

  POINT_TYPE = 'Point'                  # single Position
  MULTI_POINT_TYPE = 'MultiPoint'      # array of Positions
  LINE_STRING_TYPE = 'LineString'      # array of two or more Positions
  MULTI_LINE_STRING_TYPE = 'MultiLineString'  # array of LineString arrays
  POLYGON_TYPE = 'Polygon'              # array of LinearRing (closed LineString with 4 or more positions)
  MULTI_POLYGON_TYPE = 'Multi_polygon'

  TYPES = [POINT_TYPE, MULTI_POINT_TYPE, LINE_STRING_TYPE, MULTI_LINE_STRING_TYPE, POLYGON_TYPE, MULTI_POLYGON_TYPE]

  include CouchRest::Model::CastedModel

  property :type
  property :coordinates   # an array or positions

end