require 'rdf/couchdb'
class LinkedData::Type < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  unique_id :uri

  belongs_to :vocabulary, :class_name => "LinkedData::Vocabulary"

  # Properties denote a HAS A relationship. For example, iPublic Has a url (property) of
  # http://ipublic.org (value)
  property :properties, [LinkedData::Property]
  
  # Included types support set-based inclusion for building atop existing vocabulary definitions and to support 
  # inferencing.  For example, a resident is always a person, designating someone as a resident will 
  # provide access both to resident and person properties. Note: included properties aren't inheritance
  collection_of :included_types, :class_name => 'LinkedData::Type'
  
  property :uri, String
  property :term, String          # type id appended to URI.
  property :label, String         # User assigned name, RDFS#Label
  property :comment, String       # => RDFS#Comment
  property :tags, [String]

  property :enumerations           # Hash of key/value lookups

  timestamps!

  validates_presence_of :term
  validates_presence_of :vocabulary_id
  validates_uniqueness_of :uri, :view => 'all'

  ## Callbacks
  before_create :generate_uri

  design do
    view :by_term
    view :by_label
    view :by_vocabulary_id
    
    view :tag_list,
      :map =>
        "function(doc) {
          if (doc['model'] == 'LinkedData::Type' && doc.tags) {
            doc.tags.forEach(function(tag) {
              emit(tag, 1); 
              });
            }
          }"

    view :included_type_ids,
      :map =>
        "function(doc) {
          if (doc['model'] == 'LinkedData::Type' && doc.included_type_ids) {
            doc.included_type_ids.forEach(function(included_type_id) {
              emit(included_type_id, 1); 
              });
            }
          }"

  end

  def compound?
    self.properties.length > 0 ? true : false
  end

  def self.find_by_vocabulary_id(vocab_id)
    self.by_vocabulary_id(:key => vocab_id)
  end

private
  def generate_uri
    self.label ||= self.term
    rdf_uri = RDF::URI.new(self.vocabulary.uri)/self.vocabulary.property_delimiter + self.term
    self.uri = rdf_uri.to_s
  end

end
