class OmLinkedData::Type < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  unique_id :identifier

  belongs_to :vocabulary, :class_name => "OmLinkedData::Vocabulary"
  collection_of :properties, :class_name => 'OmLinkedData::Property' 
  collection_of :types, :class_name => 'OmLinkedData::Type'
  
  property :identifier
  property :label, String         # User assigned name, RDFS#Label
  property :comment, String       # => RDFS#Comment
  property :tags, [String]

  property :term, String          # type id appended to URI. preserves string case if provided, 
                                  #   adapted from "label" property if not provided
  property :uri, String


  timestamps!

  validates_presence_of :label
  validates_presence_of :vocabulary_id
  validates_uniqueness_of :identifier, :view => 'all'

  view_by :uri
  view_by :label
  view_by :term
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
    self.term.nil? ? self.term = escape_string(self.label.downcase) : self.term = escape_string(self.term)
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
