core_collection = ::OmLinkedData::Collection.find_by_label("Core")
xsd_float = ::OmLinkedData::Type.find_by_term(:key => "float")
xsd_string = ::OmLinkedData::Type.find_by_term(:key => "string")

comment = "A geospatial data interchange format based on JavaScript Object Notation (JSON). See: http://geojson.org/geojson-spec.html"

vocab = ::OmLinkedData::Vocabulary.new(:base_uri => "http://civicopenmedia.us/vocabularies/", 
                                        :label => "GeoJSON",
                                        :term => "GeoJSON",
                                        :property_delimiter => "#",
                                        :collection => core_collection,
                                        :comment => comment
                                        ).save


gj_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, 
                                        :label => "type", 
                                        :enumerations => ["Point", "MultiPoint", "LineString", "MultiLineString",
                                          "Polygon", "MultiPolygon"],
                                        :expected_type => xsd_string).save
                                        
xcoord = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "X", :expected_type => xsd_float).save
ycoord = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Y", :expected_type => xsd_float).save
zcoord = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Z", :expected_type => xsd_float).save

coord_type = ::OmLinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Position",
                                      :properties => [xcoord, ycoord, zcoord]
                                      ).save

geometry_type = ::OmLinkedData::Type.new(:vocabulary => vocab, 
                                          :label => "Point", 
                                          :properties => [gj_prop, xcoord, ycoord, zcoord]
                                          ).save

vocab.types << geometry_type
vocab.save!