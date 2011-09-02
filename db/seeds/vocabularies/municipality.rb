# Municipality
core_collection = LinkedData::Collection.find_by_label("Core")
xsd_string = LinkedData::Type.find_by_term(:key => "string")

comment = "A vocabulary for describing a jurisdiction or incorporated area."
tags = ["location", "place"]

vocab = LinkedData::Vocabulary.create!(:base_uri => "http://civicopenmedia.us/vocabularies", 
                                        :collection => core_collection,
                                        :label => "OpenMedia Municipality Vocabulary",
                                        :term => "Municipality",
                                        :property_delimiter => "#",
                                        :curie_prefix => "muni",
                                        :comment => comment,
                                        :tags => tags
                                        )

name_prop = LinkedData::Property.create!(:vocabulary => vocab, 
                                          :label => "Name", 
                                          :term => "name", 
                                          :expected_type => xsd_string,
                                          :comment => "Official place name"
                                          )                              

source_prop = LinkedData::Property.create!(:vocabulary => vocab, 
                                          :label => "Source",
                                          :term => "source", 
                                          :expected_type => xsd_string,
                                          :comment => "The URL or other identifier of authority where municipal name was obtained"
                                          )                              

source_prop_id = LinkedData::Property.create!(:vocabulary => vocab, 
                                          :label => "Source ID",
                                          :term => "source_id", 
                                          :expected_type => xsd_string,
                                          :comment => "The Source authority's URI or other key for municipal name"
                                          )                              

geojson_point_type = OmLinkedData::Type.find_by_uri(:key => "http://civicopenmedia.us/vocabularies/GeoJSON#Point")

vocab.properties << name_prop << source_prop << source_prop_id << geojson_point_type
vocab.save!
