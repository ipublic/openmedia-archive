## Retrieve base types from Commons
# core_collection = LinkedData::Collection.get("http://openmedia.dev/om/collections#core")
xsd_string = RDF::XSD.string.to_s
xsd_float = RDF::XSD.float.to_s

comment = "A geospatial data interchange format based on JavaScript Object Notation (JSON). See: http://geojson.org/geojson-spec.html"

vocab = LinkedData::Vocabulary.create!(:base_uri => "http://civicopenmedia.us/vocabularies/", 
                                        :label => "GeoJSON",
                                        :term => "GeoJSON",
                                        :property_delimiter => "#",
                                        :authority => @om_site.authority,
                                        :comment => comment
                                        )


gj_prop = LinkedData::Property.new(:term => "type", 
                                   :enumerations => ["Point", "MultiPoint", "LineString", "MultiLineString",
                                          "Polygon", "MultiPolygon"],
                                   :expected_type => xsd_string)
                                        
xcoord = LinkedData::Property.new(:term => "X", :expected_type => xsd_float)
ycoord = LinkedData::Property.new(:term => "Y", :expected_type => xsd_float)
zcoord = LinkedData::Property.new(:term => "Z", :expected_type => xsd_float)

coord_type = LinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Position",
                                      :term => "Position",
                                      :tags => ["gis", "intrinsic"]
                                      )

coord_type.properties << xcoord << ycoord << zcoord
coord_type.save!

point_type = LinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Point", 
                                      :term => "Point",
                                      :tags => ["gis", "intrinsic"]
                                      )

point_type.properties << gj_prop << xcoord << ycoord << zcoord
point_type.save!

vocab.types << point_type
vocab.save!