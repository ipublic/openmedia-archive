class Schema::Vocabulary < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  unique_id :identifier

  belongs_to :collection, :class_name => "Schema::Collection"
  belongs_to :namespace, :class_name => "Schema::Namespace"
  
  property :identifier, String
  property :label, String       # User assigned name, RDFS#Label
  property :comment, String     # RDFS#Comment
  property :tags, [String]
  property :properties, [Schema::Property]

#  property :type, String        # RDFS.domain, => foaf:Agent
  property :geometries, [GeoJson::Geometry]
  
  timestamps!

  validates_presence_of :label, :namespace_id, :collection_id
  validates_uniqueness_of :identifier, :view => 'all'
  
  ## Callbacks
  before_create :generate_identifier

  view_by :label
  view_by :collection_id
  view_by :namespace_id
    
  view_by :tags,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'Schema::Vocabulary' && doc.tags) {
          doc.tags.forEach(function(tag) {
            emit(tag, 1); 
            });
          }
        }"
      
  view_by :has_geometry,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'Schema::Vocabulary') && (doc.geometries.length > 0 )) { 
          doc.geometries.forEach(function(geometry) {
            emit(geometry, 1);
            });
          }
        }"
        
  ##
  # Returns the Vocabularies for passed Namespace.
  #
  # @return [Vocabulary]
  def self.find_by_namespace_id(ns_id)
    self.by_namespace_id(:key => ns_id)
  end

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
  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.namespace.authority_uri.to_s.downcase + '_' +
                         label.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  

end