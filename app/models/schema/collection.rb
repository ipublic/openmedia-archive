class Schema::Collection < CouchRest::Model::Base

  use_database TYPES_DATABASE
  unique_id :identifier

  property :identifier, String
  property :label, String       # User assigned name, RDFS#Label
  property :comment, String     # RDFS#Comment
  property :namespace, Schema::Namespace
  property :tags, [String]

  timestamps!

  validates_presence_of :label, :namespace
  validates_uniqueness_of :identifier, :view => 'all'

  ## Callbacks
  before_create :generate_identifier

  view_by :label
  
  view_by :tags,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'Schema::Collection' && doc.tags) {
          doc.tags.forEach(function(tag) {
            emit(tag, 1); 
            });
          }
        }"
      
  view_by :iri_base,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'Schema::Collection') && (doc.namespace['iri_base'] != null)) { 
            emit(doc.namespace['iri_base'], null);
            }
        }"


  def vocabularies
    Schema::Vocabulary.by_collection_id(:key => self.identifier)
  end

private
  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.namespace.alias.to_s.downcase + '_' +
                         label.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end

end