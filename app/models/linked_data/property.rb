class LinkedData::Property
  include CouchRest::Model::Embeddable
  
  property :term, String                              # Escaped vocabulary name suitable for inclusion in IRI
  property :label, String                             # RDFS#Label
  property :expected_type, String                     # URI
  property :comment, String                           # RDFS#Comment
  property :enumerations
  property :deprecated, TrueClass, :default => false  # Deprecated properties may not be used 
                                                       # for future vocabularies            

  # def initialize(options={})
  #   super(options)
  #   raise "you must provide a term value" if self.term.nil?
  # end

  def term=(val)
    write_attribute('term', val)
    write_attribute('label', val) if read_attribute('label').nil?
  end
  
  # def label
  #   if read_attribute('label').nil?
  #     write_attribute('label', read_attribute('term')) unless read_attribute('term').nil?
  #   end
  #   read_attribute('label')
  # end

  def deprecated?
    self.deprecated
  end

end