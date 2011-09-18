## Retrieve base types from Commons
# core_collection = LinkedData::Collection.get("http://openmedia.dev/om/collections#core")
xsd_string = RDF::XSD.string.to_s
xsd_float = RDF::XSD.float.to_s

comment = "A basic RDF vocabulary with a namespace for representing latitude, longitude and other information about spatially-located things, using WGS84 as a reference datum"

vocab = LinkedData::Vocabulary.new(:base_uri => "http://www.w3.org/2003/01/geo/", 
                                          :term => "wgs84_pos",
                                          :property_delimiter => "#",
                                          :curie_prefix => "geo",
                                          :authority => @om_site.authority,
                                          :label => "W3C Geo Vocabulary",
                                          :comment => comment
                                          )

prop_lat = LinkedData::Property.new(:label => "Latitude", 
                                        :term => "lat",
                                        :expected_type => xsd_float,
                                        :tags => ["gis", "northing", "coordinate"]
                                        )
                                      
prop_lng = LinkedData::Property.new(:label => "Longitude", 
                                        :term => "long",
                                        :expected_type => xsd_float,
                                        :tags => ["gis", "easting", "coordinate"]
                                        )                              

vocab.properties << prop_lat << prop_lng 
vocab.save!

