
ns = LinkedData::Namespace.new("http://om.civicopenmedia.us")
topic_term = "street_addresses"
topic_label = "Street addresses"
instance_db_name = COMMONS_DATABASE.name
vocab = LinkedData::Vocabulary.get("vocabulary_openmedia_dev_om_street_address")

LinkedData::Topic.new(:authority => ns.authority, 
                      :term => topic_term, 
                      :label => topic_label,
                      :vocabulary => vocab,
                      :instance_database_name => instance_db_name).save!
