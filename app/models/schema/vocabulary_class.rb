class Schema::VocabularyClass < Hash
  include CouchRest::Model::CastedModel

  property :label, String       # User assigned name, RDFS#Label
  property :commment, String    # RDFS#Comment

  property :terms, [Schema::PropertyDefinition]

end
