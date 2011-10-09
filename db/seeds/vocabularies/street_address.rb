# core_collection = LinkedData::Collection.get("http://openmedia.dev/om/collections#core")
xsd_string = RDF::XSD.string.to_s

# Extended from Google json format. See: http://code.google.com/apis/maps/documentation/geocoding/#JSON
props = []
props << LinkedData::Property.new(:label => "Formatted address", :term => "formatted_address", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "Route", :term => "route", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "Intersection", :term => "intersection", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "Political", :term => "political", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "Country", :term => "country", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "State", :term => "state", :alias => "administrative_area_level_1", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "County", :term => "county", :alias => "administrative_area_level_2", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "Administrative Area Level 3", :term => "administrative_area_level_3", :expected_type => xsd_string)
props << LinkedData::Property.new(:label => "Colloquial Area", :term => "colloquial_area", :expected_type => xsd_string)
props << LinkedData::Property.new(:label => "City", :term => "city", :alias => "locality", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "Sublocality", :term => "sublocality", :expected_type => xsd_string)
props << LinkedData::Property.new(:label => "Neighborhood", :term => "neighborhood", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "Premise", :term => "premise", :expected_type => xsd_string)
props << LinkedData::Property.new(:label => "Subpremise", :term => "subpremise", :expected_type => xsd_string)
props << LinkedData::Property.new(:label => "Zipcode", :term => "zipcode", :alias => "postal_code", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "Natural feature", :term => "natural_feature", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "Airport", :term => "airport", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "Park", :term => "park", :expected_type => xsd_string, :key => true)
props << LinkedData::Property.new(:label => "Point of Interest", :term => "point_of_interest", :expected_type => xsd_string, :key => true)

props << LinkedData::Property.new(:label => "Post Box", :term => "post_box", :expected_type => xsd_string)
props << LinkedData::Property.new(:label => "Street number", :term => "street_number", :expected_type => xsd_string)
props << LinkedData::Property.new(:label => "Block", :term => "one_hundred_block", :expected_type => xsd_string)
props << LinkedData::Property.new(:label => "Floor", :term => "floor", :expected_type => xsd_string)
props << LinkedData::Property.new(:label => "Room", :term => "room", :expected_type => xsd_string)

# Add GeoJson Point type
# addr_type = LinkedData::Type.create!(:vocabulary => vocab, 
#                                       :label => "Street address",
#                                       :term => "street_address",
#                                       :properties => props,
#                                       :tags => ["address", "site", "intersection", "intrinsic"]
#                                       )

gtype = LinkedData::Type.get("type_openmedia_dev_om_geojson_point")
comment = "A standard format for street addresses extended from Google geocoder"
LinkedData::Vocabulary.create!(:base_uri => "http://civiopenmedia.us/vocabularies/", 
                                        :label => "Street address",
                                        :term => "street_address",
                                        :property_delimiter => "#",
                                        :curie_prefix => "addr",
                                        :authority => @om_site.authority,
                                        :properties => props,
                                        :tags => ["address", "site", "intersection", "intrinsic"],
                                        :comment => comment
                                        )

