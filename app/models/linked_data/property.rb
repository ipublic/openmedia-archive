class LinkedData::Property
  include CouchRest::Model::Embeddable
  
  property :term, String                              # Escaped vocabulary name suitable for inclusion in IRI
  property :alias, String                             # Alternate term
  property :label, String                             # RDFS#Label
  property :expected_type, String                     # URI for data type
  property :format, String                            # Output format styling
  property :key, TrueClass, :default => false         # Create index on this property?
  property :comment, String                           # RDFS#Comment
  property :deprecated, TrueClass, :default => false  # Deprecated properties may not be used 
                                                       # for future vocabularies            
  def term=(val)
    write_attribute('term', val)
    write_attribute('label', val) if read_attribute('label').nil?
  end
  
  def deprecated?
    self.deprecated
  end

end