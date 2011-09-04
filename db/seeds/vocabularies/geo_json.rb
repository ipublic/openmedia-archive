## Retrieve base types from Commons
core_collection = LinkedData::Collection.get("http://openmedia.dev/om/collections#core")
xsd_string = LinkedData::Type.get("http://www.w3.org/2001/XMLSchema#string")
xsd_float = LinkedData::Type.get("http://www.w3.org/2001/XMLSchema#float")

comment = "A geospatial data interchange format based on JavaScript Object Notation (JSON). See: http://geojson.org/geojson-spec.html"

vocab = LinkedData::Vocabulary.create!(:base_uri => "http://civicopenmedia.us/vocabularies/", 
                                        :label => "GeoJSON",
                                        :term => "GeoJSON",
                                        :property_delimiter => "#",
                                        :collection => core_collection,
                                        :comment => comment
                                        )


gj_prop = LinkedData::Property.new(:term => "type", 
                                   :enumerations => ["Point", "MultiPoint", "LineString", "MultiLineString",
                                          "Polygon", "MultiPolygon"],
                                   :expected_type => xsd_string.uri)
                                        
xcoord = LinkedData::Property.new(:term => "X", :expected_type => xsd_float.uri)
ycoord = LinkedData::Property.new(:term => "Y", :expected_type => xsd_float.uri)
zcoord = LinkedData::Property.new(:term => "Z", :expected_type => xsd_float.uri)

coord_type = LinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Position",
                                      :term => "Position"
                                      )

coord_type.properties << xcoord << ycoord << zcoord
coord_type.save!

point_type = LinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Point", 
                                      :term => "Point"
                                      )

point_type.properties << gj_prop << xcoord << ycoord << zcoord
point_type.save!

vocab.types << point_type
vocab.save!