class OmLinkedData::Vocabulary < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  unique_id :identifier

  belongs_to :collection, :class_name => "OmLinkedData::Collection"
  
  property :identifier, String, :alias => :subject
  property :label, String       # User assigned name, RDFS#Label
  property :comment, String     # RDFS#Comment
  property :tags, [String]

  property :uri, String
  property :term, String
  
  property :base_uri, String
  property :subdomain, String
  property :authority, String
  
  collection_of :types, :class_name => 'OmLinkedData::Type'  # Props with same semantic meaning

  ## TODO -- move geometries into Properties
  # property :geometries, [GeoJson::Geometry]
  
  timestamps!

  validates_presence_of :label
  validates_presence_of :collection_id
  validates_uniqueness_of :identifier, :view => 'all'
  
  ## Callbacks
  before_create :generate_uri
  before_create :generate_identifier

  view_by :label
  view_by :collection_id
  view_by :uri
  
  view_by :tags,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'OmLinkedData::Vocabulary' && doc.tags) {
          doc.tags.forEach(function(tag) {
            emit(tag, 1); 
            });
          }
        }"
    
  # view_by :has_geometry,
  #   :map => 
  #     "function(doc) {
  #       if ((doc['couchrest-type'] == 'OmLinkedData::Vocabulary') && (doc.geometries.length > 0 )) { 
  #         doc.geometries.forEach(function(geometry) {
  #           emit(geometry, 1);
  #           });
  #         }
  #       }"
  
  ##
  # Returns the Vocabularies for passed Collection.
  #
  # @return [Vocabulary]
  def self.find_by_collection_id(col_id)
    self.by_collection_id(:key => col_id)
  end

  ##
  # Returns a JSON-LD (Linked Data) representation of this vocabulary.
  #
  # @return {JSON-LD}
  def to_jsonld

  end

  ##
  # Returns a hash of CURIE and Namespaces used to define this vocabulary
  #
  # @return {CURIE key, Namespace value}
  def context
    # namespaces = Hash.new
    # self.properties.each { |prop| namespaces[prop.namespace.alias.to_s] = prop.namespace.iri_base.to_s }
    # namespaces
  end
  
  ## Return a Hash with URIs as key's and Vocaulary hashes in an associated Array
  ## Calling with an empty Collection_id will return all Vocaularies
  def self.sort_by_base_uri(collection_id = '')
    
    @sorted_vocabularies = Hash.new
    if collection_id.empty?
      all_vocabs = OmLinkedData::Vocabulary.all
    else
      all_vocabs = OmLinkedData::Vocabulary.by_collection_id(:key => collection_id)
    end
    
    all_vocabs.each do |v| 
      @sorted_vocabularies.key?(v.base_uri) ? @sorted_vocabularies[v.base_uri] << v : @sorted_vocabularies[v.base_uri] = Array.[](v)
    end
    @sorted_vocabularies
  end
  
private
  def generate_uri
    self.term = escape_string(self.label)

    # base_uri => "http://dcgov.civicopenmedia.us"
    parts = base_uri.split('.')
    self.subdomain = parts.first.split("http://").last
    domain = base_uri.split(subdomain + '.').last.gsub('.','_')

    # authority => "civicopenmedia_us_dcgov"
    self.authority = domain + '_' + subdomain

    rdf_uri = RDF::URI.new('http://civicopenmedia.us')/self.subdomain/"vocabularies#"/self.term
    self.uri = rdf_uri.to_s
  end

  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.collection.authority + '_' + self.term if new?
  end

  def escape_string(str)
    str.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end
  
end