class LinkedData::Property
  include CouchRest::Model::Embeddable
  
  property :term, String                              # Escaped vocabulary name suitable for inclusion in IRI
  property :label, String                             # RDFS#Label
  property :expected_type, String                     # URI
  property :comment, String                           # RDFS#Comment
  property :enumerations
  property :deprecated, TrueClass, :default => false  # Deprecated properties may not be used 
                                                       # for future vocabularies            

  def deprecated?
    self.deprecated
  end

  # def term=(value)
  #   self.term = value
  #   sef.label ||= self.term
  # end

end