require 'rdf/couchdb'
class LinkedData::Collection < CouchRest::Model::Base

  use_database VOCABULARIES_DATABASE
  unique_id :uri
  
  property :term, String        # Escaped vocabulary name suitable for inclusion in IRI
  property :label, String       # User assigned name, RDFS#Label
  property :comment, String     # RDFS#Comment
  property :tags, [String]
  property :hidden, TrueClass, :default => false
  
  # property :namespace, LinkedData::Namespace
  property :base_uri, String
  property :authority, String
  property :uri, String

  timestamps!
  
  validates_presence_of :term
  validates_presence_of :base_uri
  validates_presence_of :authority
  validates_uniqueness_of :uri, :view => 'all'

  ## Callbacks
  before_create :generate_uri
  # before_create :generate_identifier
  
  def namespace=(ns={})
    self.base_uri = ns.base_uri unless ns.base_uri.nil?
    self.authority = ns.authority unless ns.authority.nil?
  end
  
  def namespace
    Hash[:base_uri => self.base_uri, :authority => self.authority]
  end

  design do
    view :by_label
    view :by_term
    view :by_base_uri
    view :by_authority
    
    # view :by_base_uri,
    #   :map =>
    #     "function(doc) {
    #       if (doc['type'] == 'LinkedData::Collection' && doc['namespace']['base_uri']) {
    #         emit(doc['namespace']['base_uri']);
    #         }
    #       }"
    # 
    # view :by_authority,
    # :map =>
    #   "function(doc) {
    #     if (doc['type'] == 'LinkedData::Collection' && doc['namespace']['authority']) {
    #       emit(doc['namespace']['authority']);
    #       }
    #     }"
    
    view :tag_list,
      :map =>
        "function(doc) {
          if (doc['model'] == 'LinkedData::Collection' && doc.tags) {
            doc.tags.forEach(function(tag) {
              emit(tag, 1); 
              });
            }
          }"
  end
  
  ## Return a Hash with URI's as keys and Collection hashes in an associated Array
  ## Calling with an empty URI will return all Collections
  def self.sort_by_base_uri(uri = '')
    @sorted_collections = Hash.new
    if uri.empty?
      all_collections = LinkedData::Collection.all
    else
      all_collections = LinkedData::Collection.by_base_uri(:key => uri)
    end
    
    all_collections.each do |c| 
      @sorted_collections.key?(c.base_uri) ? @sorted_collections[c.base_uri] << c : @sorted_collections[c.base_uri] = Array.[](c)
    end
    @sorted_collections
  end

private
  def generate_uri
    self.label ||= self.term
    rdf_uri = RDF::URI.new(self.base_uri)/"collections#"/escape_string(self.term)
    self.uri = rdf_uri.to_s
  end

  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.authority + '_' + 
                         escape_string(self.term) if new?
  end
  
  def escape_string(str)
    str.gsub(/[^A-Za-z0-9]/,'_').squeeze('_')
  end
  
end