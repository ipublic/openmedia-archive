class OmLinkedData::Type < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  unique_id :identifier

  belongs_to :vocabulary, :class_name => "OmLinkedData::Vocabulary"

  property :identifier
  property :label, String         # User assigned name, RDFS#Label
  property :comment, String       # => RDFS#Comment
  property :tags, [String]

  property :uri, String
  property :term, String

  collection_of :types, :class_name => 'OmLinkedData::Type'

  timestamps!

  validates_presence_of :label
  validates_presence_of :vocabulary_id
  validates_uniqueness_of :identifier, :view => 'all'

  view_by :uri
  view_by :label
  view_by :vocabulary_id
  
  ## Callbacks
  before_create :generate_uri
  before_create :generate_identifier

  view_by :tags,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'OmLinkedData::Type' && doc.tags) {
          doc.tags.forEach(function(tag) {
            emit(tag, 1); 
            });
          }
        }"
  
  def compound?
    self.properties.length > 0 ? true : false
  end

  def self.find_by_vocabulary_id(vocab_id)
    self.by_vocabulary_id(:key => vocab_id)
  end

private
  def generate_uri
    self.term = escape_string(self.label)

    rdf_uri = RDF::URI.new(self.vocabulary.uri)/self.term
    self.uri = rdf_uri.to_s
  end

  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.vocabulary.authority + '_' + self.term if new?
  end

  def escape_string(str)
    str.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end


end
