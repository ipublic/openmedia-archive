require 'rdf/couchdb'
class LinkedData::Vocabulary < CouchRest::Model::Base
  
  attr_accessor :key_list
  
  use_database VOCABULARIES_DATABASE
  unique_id :identifier

  # belongs_to :collection, :class_name => "LinkedData::Collection"
  
  property :identifier, String
  property :uri, String
  property :term, String
  property :label, String       # User assigned name, RDFS#Label
  property :comment, String     # RDFS#Comment
  property :tags, [String]

  property :base_uri, String
  property :authority, String
  
  property :curie_prefix, String
  property :curie_suffix, String
  property :property_delimiter, String, :default => "/"
  property :context
  
  property :properties, [LinkedData::Property]
  collection_of :types, :class_name => 'LinkedData::Type'

  # Provide enumerations in the following example format:
    # p = {"clown" => {"c" => "circus", "r" => "rodeo"}, "category" => {"a" => "animal", "v" => "vegetable", "m" => "mineral"}}
  property :enumerations, :default => {}

  ## TODO -- move geometries into Properties
  # property :geometries, [GeoJson::Geometry]
  
  timestamps!

  validates_presence_of :term
  validates_presence_of :base_uri
  validates_presence_of :authority
  # validates_presence_of :collection_id
  validates_uniqueness_of :identifier, :view => 'all'
  
  
  ## Callbacks
  before_create :generate_identifier
  before_create :generate_uri

  design do
    view :by_label
    view :by_uri
    view :by_curie_prefix
    view :by_authority
  
    view :tag_list,
      :map =>
        "function(doc) {
          if (doc['model'] == 'LinkedData::Vocabulary' && doc.tags) {
            doc.tags.forEach(function(tag) {
              emit(tag, 1); 
              });
            }
          }"
          
  end
  
  # view_by :has_geometry,
  #   :map => 
  #     "function(doc) {
  #       if ((doc['model'] == 'LinkedData::Vocabulary') && (doc.geometries.length > 0 )) { 
  #         doc.geometries.forEach(function(geometry) {
  #           emit(geometry, 1);
  #           });
  #         }
  #       }"
  
  
  def key_list
    return [] if self.properties.nil?
    @key_list ||= self.properties.inject([]) {|list, k| k.key ? list.push(k.term) : list }
  end
  
  def curie
    Hash[self.curie_prefix, self.curie_suffix] if self.curie_prefix && self.curie_suffix
  end
  
  def namespace=(ns={})
    self.base_uri = ns.base_uri unless ns.base_uri.nil?
    self.authority = ns.authority unless ns.authority.nil?
  end
  
  def namespace
    Hash[:base_uri => self.base_uri, :authority => self.authority]
  end

  def decode(property_name, key)
    self.enumerations[property_name][key]
  end

  ##
  # Returns the Vocabularies for passed Collection.
  #
  # @return [Vocabulary]
  # def self.find_by_collection_id(col_id)
  #   self.by_collection_id(:key => col_id)
  # end

  ##
  # Returns a JSON representation of this vocabulary.
  #
  # @return {JSON}
  def to_json
    # all_props_hsh = Hash.new
    # self.properties.each do |prop|
    #   prop_hsh[prop.]
    # end
    # 
    # prop_hash = Hash.new {}
    # 
    # self.types.each do |t|
    #   
    #   {|t| puts t.label ; t.properties.each {|p| puts '|-' + p.label}}
    # end

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
  # def self.sort_by_base_uri(collection_id = '')
  #   @sorted_vocabularies = Hash.new
  #   if collection_id.empty?
  #     all_vocabs = LinkedData::Vocabulary.all
  #   else
  #     all_vocabs = LinkedData::Vocabulary.by_collection_id(:key => collection_id)
  #   end
  #   
  #   all_vocabs.each do |v| 
  #     @sorted_vocabularies.key?(v.base_uri) ? @sorted_vocabularies[v.base_uri] << v : @sorted_vocabularies[v.base_uri] = Array.[](v)
  #   end
  #   @sorted_vocabularies
  # end
  
  ## Return a Hash with URIs as key's and Vocaulary hashes in an associated Array
  ## Calling with an empty Collection_id will return all Vocaularies
  # def self.sort_by_authority(collection_id = '')
  #   @sorted_vocabularies = Hash.new
  #   if collection_id.empty?
  #     all_vocabs = LinkedData::Vocabulary.all
  #   else
  #     all_vocabs = LinkedData::Vocabulary.by_collection_id(:key => collection_id)
  #   end
  #   
  #   all_vocabs.each do |v| 
  #     @sorted_vocabularies.key?(v.authority) ? @sorted_vocabularies[v.authority] << v : @sorted_vocabularies[v.authority] = Array.[](v)
  #   end
  #   @sorted_vocabularies
  # end
  
private
  def generate_uri
    self.label ||= self.term
    
    # If this is local vocabulary, construct the OM path
    if self.base_uri.include?("http://civicopenmedia.us") && !self.base_uri.include?("vocabularies")
      rdf_uri = RDF::URI.new(self.base_uri)/"vocabularies"/escape_string(self.term)
    else
      rdf_uri = RDF::URI.new(self.base_uri)/self.term
    end
    self.uri = rdf_uri.to_s
  end

  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.authority + '_' + 
                         escape_string(self.term.downcase) if new?
  end

  def escape_string(str)
    str.gsub(/[^A-Za-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end
  
end