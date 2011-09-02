# XMLSchema base types
core_collection = LinkedData::Collection.find_by_label("Core")

comment = "Element and attribute datatypes used in XML Schemas and other XML specifications"
vocab = LinkedData::Vocabulary.new(:base_uri => "http://www.w3.org/2001", 
                                        :label => "XMLSchema",
                                        :term => "XMLSchema",
                                        :property_delimiter => "#",
                                        :curie_prefix => "xsd",
                                        :collection => core_collection,
                                        :comment => comment
                                        ).save
                                          
["base64Binary", "boolean", "byte", "date", "dateTime", "double", "duration", 
  "float", "integer", "long", "short", "string", "time"].each do |term|
  new_type = LinkedData::Type.new(:vocabulary => vocab, :term => term, :label => term).save
  vocab.types << new_type
end

vocab.save!                         
