# XMLSchema base types
# core_collection = LinkedData::Collection.get("http://openmedia.dev/om/collections#core")

comment = "Element and attribute datatypes used in XML Schemas and other XML specifications"
vocab = LinkedData::Vocabulary.new(:base_uri => "http://www.w3.org/2001", 
                                        :label => "XMLSchema",
                                        :term => "XMLSchema",
                                        :property_delimiter => "#",
                                        :curie_prefix => "xsd",
                                        :authority => @om_site.authority,
                                        :comment => comment
                                        ).save
                                          
["base64Binary", "boolean", "byte", "date", "dateTime", "double", "duration", 
  "float", "integer", "long", "short", "string", "time"].each do |term|
  new_type = LinkedData::Type.new(:vocabulary => vocab, 
                                  :term => term, 
                                  :label => term.capitalize,
                                  :tags => ["intrinsic"]).save
  vocab.types << new_type
end

vocab.save!                         
