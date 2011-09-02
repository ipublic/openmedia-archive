## Initialize the Commons Vocabularies
core_collection = LinkedData::Collection.find_by_label("Core")
xsd_float = LinkedData::Type.find_by_term(:key => "float")
xsd_string = LinkedData::Type.find_by_term(:key => "string")

comment = "A basic RDF vocabulary with a namespace for representing latitude, longitude and other information about spatially-located things, using WGS84 as a reference datum"

vocab = LinkedData::Vocabulary.new(:base_uri => "http://www.w3.org/2003/01/geo/", 
                                          :term => "wgs84_pos",
                                          :property_delimiter => "#",
                                          :curie_prefix => "geo",
                                          :collection => core_collection,
                                          :label => "W3C Geo Vocabulary",
                                          :comment => comment
                                          ).save

prop_lat = LinkedData::Property.create!(:vocabulary => vocab, 
                                        :label => "Latitude", 
                                        :term => "lat",
                                        :expected_type => xsd_float,
                                        :tags => ["northing", "coordinate"]
                                        )
                                      
prop_lng = LinkedData::Property.create!(:vocabulary => vocab, 
                                        :label => "Longitude", 
                                        :term => "long",
                                        :expected_type => xsd_float,
                                        :tags => ["easting", "coordinate"]
                                        )                              

vocab.properties << prop_lat << prop_lng 
vocab.save!

