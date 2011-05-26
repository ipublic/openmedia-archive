class Schema::Vocabulary < CouchRest::Model::Base

  property :namespace, Schema::Namespace
  property :label, String       # User assigned name, RDFS#Label
  property :commment, String    # RDFS#Comment

  property :context # A hash of Namespaces used to define this vocabulary
  property :classes, [Schema::VocabularyClass]
  
  property :type, String      # => RDFS.domain

  timestamps!
  
  def to_jsonld
  end
  

end