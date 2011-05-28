class Schema::PropertyDefinition < Hash
  include CouchRest::Model::CastedModel

  property :label, String       # User assigned name, RDFS#Label
  property :term, String        # Escaped vocabulary name suitable for inclusion in IRI
  property :definition, String  # Description for this property
  property :commment, String    # RDFS#Comment
  
  property :rdf_type            # This support type coercion
  
#  property :range, :predicate=>RDFS.range
  
  
  def curie
    # Property Name in Compact URI form => "foaf:name"
#    self.local_namespace + ':' + self.term
  end
  
end