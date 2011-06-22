class OmLinkedData::Collection < CouchRest::Model::Base

  use_database TYPES_DATABASE
  unique_id :identifier
  
  property :identifier, String
  property :label, String       # User assigned name, RDFS#Label
  property :comment, String     # RDFS#Comment
  property :tags, [String]
  property :hidden, TrueClass, :default => false

  property :base_uri, String
  property :subdomain, String
  property :authority, String

  property :uri, String
  property :term, String                 # Escaped vocabulary name suitable for inclusion in IRI

  timestamps!

  validates_presence_of :label
  validates_presence_of :base_uri
  validates_presence_of :authority
  validates_uniqueness_of :identifier, :view => 'all'

  ## Callbacks
  before_create :generate_uri
  before_create :generate_identifier

  view_by :label
  view_by :authority
  view_by :base_uri
  view_by :term
  
  view_by :tags,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'OmLinkedData::Collection' && doc.tags) {
          doc.tags.forEach(function(tag) {
            emit(tag, 1); 
            });
          }
        }"

  ## Return a Hash with URI's as keys and Collection hashes in an associated Array
  ## Calling with an empty URI will return all Collections
  def self.sort_by_base_uri(uri = '')
    @sorted_collections = Hash.new
    if uri.empty?
      all_collections = OmLinkedData::Collection.all
    else
      all_collections = OmLinkedData::Collection.by_base_uri(:key => uri)
    end
    
    all_collections.each do |c| 
      @sorted_collections.key?(c.base_uri) ? @sorted_collections[c.base_uri] << c : @sorted_collections[c.base_uri] = Array.[](c)
    end
    @sorted_collections
  end

private
  def generate_uri
    self.term ||= self.label.downcase
    rdf_uri = RDF::URI.new(self.base_uri)/"collections#"/escape_string(self.label.downcase)
    self.uri = rdf_uri.to_s
  end

  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.authority + '_' + 
                         escape_string(self.term) if new?
  end
  
  def escape_string(str)
    str.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end
  
end