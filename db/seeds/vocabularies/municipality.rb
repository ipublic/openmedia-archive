# Municipality
core_collection = ::OmLinkedData::Collection.find_by_label("Core")
xsd_string = ::OmLinkedData::Type.find_by_term(:key => "string")

comment = "A vocabulary for describing a jurisdiction or incorporated area."
tags = ["location", "place"]

vocab = ::OmLinkedData::Vocabulary.new(:base_uri => "http://civicopenmedia.us/vocabularies", 
                                        :collection => core_collection,
                                        :label => "OpenMedia Municipality Vocabulary",
                                        :term => "Municipality",
                                        :property_delimiter => "#",
                                        :curie_prefix => "muni",
                                        :comment => comment,
                                        :tags => tags
                                        ).save

prop_name = ::OmLinkedData::Property.create!(:vocabulary => vocab, 
                                          :label => "Name", 
                                          :term => "name", 
                                          :expected_type => xsd_string,
                                          :comment => "Official place name"
                                          )                              

prop_source = ::OmLinkedData::Property.create!(:vocabulary => vocab, 
                                          :label => "Source",
                                          :term => "source", 
                                          :expected_type => xsd_string,
                                          :comment => "The URL or other identifier of authority where municipal name was obtained"
                                          )                              

prop_source_id = ::OmLinkedData::Property.create!(:vocabulary => vocab, 
                                          :label => "Source ID",
                                          :term => "source_id", 
                                          :expected_type => xsd_string,
                                          :comment => "The Source authority's URI or other key for municipal name"
                                          )                              

vocab.properties << prop_name << prop_source << prop_source_id
vocab.save!
