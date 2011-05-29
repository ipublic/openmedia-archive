class Schema::Vocabulary < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  unique_id :identifier

  belongs_to :collection, :class_name => "Schema::Collection"

  property :identifier, String
  property :label, String       # User assigned name, RDFS#Label
  property :comment, String     # RDFS#Comment
  property :properties, [Schema::Property]
  property :namespace, Schema::Namespace
  property :type, String        # RDFS.domain, => foaf:Agent
  property :geometries, [GeoJson::Geometry]
  
  timestamps!

  validates_presence_of :label, :namespace, :collection_id
  validates_uniqueness_of :identifier, :view => 'all'
  
  ## Callbacks
  before_create :generate_identifier

  view_by :label
  view_by :collection_id
    
  view_by :tags,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'Schema::Vocabulary' && doc.tags) {
          doc.tags.forEach(function(tag) {
            emit(tag, 1); 
            });
          }
        }"
      
  view_by :iri_base,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'Schema::Vocabulary') && (doc.namespace['iri_base'] != null)) { 
            emit(doc.namespace['iri_base'], null);
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
        
  def to_jsonld

  end

  def context
    # A hash of Namespaces used to define this vocabulary
    namespaces = Hash.new
    self.properties.each { |prop| namespaces[prop.namespace.alias.to_s] = prop.namespace.iri_base.to_s }
    namespaces
  end
  
private
  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.namespace.alias.to_s.downcase + '_' +
                         label.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  

end