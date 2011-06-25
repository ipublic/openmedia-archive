# XMLSchema base types
core_collection = ::OmLinkedData::Collection.find_by_label("Core")

comment = "Element and attribute datatypes used in XML Schemas and other XML specifications"
vocab = ::OmLinkedData::Vocabulary.new(:base_uri => "http://www.w3.org/2001", 
                                        :label => "XMLSchema",
                                        :term => "XMLSchema",
                                        :property_delimiter => "#",
                                        :curie_prefix => "xsd",
                                        :collection => core_collection,
                                        :comment => comment
                                        ).save
                                          
type_list = []
["base64Binary", "boolean", "byte", "date", "dateTime", "double", "duration", 
  "float", "integer", "long", "short", "string", "time"].each do |term|
  new_type = ::OmLinkedData::Type.new(:vocabulary => vocab, :term => term, :label => term).save
  type_list << new_type
end

vocab.types = type_list
vocab.save!                         
