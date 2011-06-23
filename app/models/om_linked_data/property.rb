class OmLinkedData::Property < CouchRest::Model::Base

  use_database TYPES_DATABASE
  unique_id :identifier

  belongs_to :vocabulary, :class_name => "OmLinkedData::Vocabulary"
  collection_of :synonyms, :class_name => 'OmLinkedData::Property'  # Props with same semantic meaning

  property :identifier
  property :label, String                             # User assigned name, RDFS#Label
  property :comment, String                           # => RDFS#Comment
  property :tags, [String]

  property :term, String                              # Escaped vocabulary name suitable for inclusion in IRI
  property :uri, String

  property :expected_type, OmLinkedData::Type         # Support type coercion
  
  property :enumerations                              # Hash of key/value lookups
  property :deprecated, TrueClass, :default => false  # Deprecated properties may not be used 
                                                       # for future vocabularies            
  timestamps!

  validates_presence_of :label
  # validates_presence_of :expected_type
  validates_presence_of :vocabulary_id
  validates_uniqueness_of :identifier, :view => 'all'
  
  before_create :generate_uri
  before_create :generate_identifier
  
  view_by :uri
  view_by :label
  view_by :term
  view_by :vocabulary_id

  view_by :tags,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'OmLinkedData::Property' && doc.tags) {
          doc.tags.forEach(function(tag) {
            emit(tag, 1); 
            });
          }
        }"

  def deprecated?
    self.deprecated
  end

  def self.find_by_vocabulary_id(vocab_id)
    self.by_vocabulary_id(:key => vocab_id)
  end
  
private
  def generate_uri
    self.term ||= escape_string(self.label)
    rdf_uri = RDF::URI.new(self.vocabulary.uri)/self.vocabulary.property_delimiter + self.term
    self.uri = rdf_uri.to_s
  end

  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.vocabulary.authority + '_' + 
                         self.vocabulary.term.downcase + '_' +
                         escape_string(self.term.downcase) if new?
  end

  def escape_string(str)
    str.gsub(/[^A-Za-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end

end