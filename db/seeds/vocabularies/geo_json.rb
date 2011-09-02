core_collection = LinkedData::Collection.find_by_label("Core")
xsd_float = LinkedData::Type.find_by_term(:key => "float")
xsd_string = LinkedData::Type.find_by_term(:key => "string")

comment = "A geospatial data interchange format based on JavaScript Object Notation (JSON). See: http://geojson.org/geojson-spec.html"

vocab = LinkedData::Vocabulary.create!(:base_uri => "http://civicopenmedia.us/vocabularies/", 
                                        :label => "GeoJSON",
                                        :term => "GeoJSON",
                                        :property_delimiter => "#",
                                        :collection => core_collection,
                                        :comment => comment
                                        )


gj_prop = LinkedData::Property.create!(:vocabulary => vocab, 
                                        :term => "type", 
                                        :enumerations => ["Point", "MultiPoint", "LineString", "MultiLineString",
                                          "Polygon", "MultiPolygon"],
                                        :expected_type => xsd_string)
                                        
xcoord = LinkedData::Property.create!(:vocabulary => vocab, :term => "X", :expected_type => xsd_float)
ycoord = LinkedData::Property.create!(:vocabulary => vocab, :term => "Y", :expected_type => xsd_float)
zcoord = LinkedData::Property.create!(:vocabulary => vocab, :term => "Z", :expected_type => xsd_float)

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