class OmLinkedData::Vocabulary < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  unique_id :identifier

  belongs_to :collection, :class_name => "OmLinkedData::Collection"
  
  property :identifier, String, :alias => :subject
  property :label, String       # User assigned name, RDFS#Label
  property :comment, String     # RDFS#Comment
  property :tags, [String]

  property :base_uri, String
  property :subdomain, String
  property :uri, String
  property :authority, String
  property :term, String

  collection_of :properties, :class_name => 'OmLinkedData::Property'  # Props with same semantic meaning
#  property :properties, [OmLinkedData::Property]
#  property :type, String        # RDFS.domain, => foaf:Agent

  ## TODO -- move geometries into Properties
  property :geometries, [GeoJson::Geometry]
  
  timestamps!

  validates_presence_of :label, :collection_id, :base_uri
  validates_uniqueness_of :identifier, :view => 'all'
  
  ## Callbacks
  before_create :generate_uri
  before_create :generate_identifier

  view_by :label
  view_by :collection_id
  view_by :authority
  view_by :base_uri
  
  view_by :tags,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'OmLinkedData::Vocabulary' && doc.tags) {
          doc.tags.forEach(function(tag) {
            emit(tag, 1); 
            });
          }
        }"
    
  view_by :has_geometry,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'OmLinkedData::Vocabulary') && (doc.geometries.length > 0 )) { 
          doc.geometries.forEach(function(geometry) {
            emit(geometry, 1);
            });
          }
        }"
  
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
  # Returns the base URI for this vocabulary.
  #
  # @return [URI]  
  def to_uri

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
  
private
  def generate_uri
    # base_uri => "http://dcgov.civicopenmedia.us"
    parts = base_uri.split('.')
    self.subdomain = parts.first.split("http://").last
    domain = base_uri.split(subdomain + '.').last.gsub('.','_')

    # authority => "civicopenmedia_us_dcgov"
    self.authority = domain + '_' + subdomain
    self.term = escape_string(self.label)

    rdf_uri = RDF::URI.new('http://civicopenmedia.us')/self.subdomain/"vocabularies#"/self.term
    self.uri = rdf_uri.to_s
  end

  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.authority + '_' + self.term if new?
  end

  def escape_string(str)
    str.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end
  
end