class OmLinkedData::Property < CouchRest::Model::Base

  # require 'json/pure' unless defined?(JSON::State) 

  use_database TYPES_DATABASE
  unique_id :identifier

  property :identifier, :init_method => 'new'
  property :label, String                             # User assigned name, RDFS#Label
  property :comment, String                           # => RDFS#Comment
  property :tags, [String]

  property :namespace, OmLinkedData::Namespace
  property :subdomain
  property :authority

  property :uri, String
  property :term, String                              # Escaped vocabulary name suitable for inclusion in IRI

  property :range                                     # => RDFS.range
  property :expected_type, OmLinkedData::Datatype     # Support type coercion
  
  property :deprecated, TrueClass, :default => false  # Deprecated propoerties may not be used 
                                                       # for future vocabularies
                                                      
  property :enumerations                               # Hash of key/value lookups
  
  collection_of :synonyms, :class_name => 'OmLinkedData::Property'  # Props with same semantic meaning
  
  timestamps!

  # validates_presence_of :label, :namespace
  validates_uniqueness_of :identifier, :view => 'all'
  
  before_create :generate_uri
  before_create :generate_identifier
  
  view_by :label

  # view_by :namespace_authority,
  #   :map =>
  #   "function(doc) {
  #     if ((doc['couchrest-type'] == 'OmLinkedData::Property') && 
  #         (doc['namespace'] != null) &&
  #         (doc['namespace']['authority'] != null)) {
  #           emit(doc['namespace']['authority'], null); 
  #           }
  #     }"
  # 
  # view_by :namespace_uri,
  #   :map =>
  #   "function(doc) {
  #     if ((doc['couchrest-type'] == 'OmLinkedData::Property') && 
  #         (doc['namespace'] != null) &&
  #         (doc['namespace']['authority'] != null)) {
  #           emit(doc['namespace']['uri'], null); 
  #           }
  #     }"
  # 
  # view_by :tags,
  #   :map =>
  #     "function(doc) {
  #       if (doc['couchrest-type'] == 'OmLinkedData::Property' && doc.tags) {
  #         doc.tags.forEach(function(tag) {
  #           emit(tag, 1); 
  #           });
  #         }
  #       }"

  # Require label and namespace properties
  # Property Term is dependent on label property
  # Property URI is dependent on namespace
  # def new(options={})
  #   raise ArgumentError, 
  #     "Requires 'label', 'subdomain' properties" unless options.include?(:label) && options.include?(:authority)
  #   super
  #   self.label = options[:label]
  #   self.term = escape_string(self.label)
  #   self.authority = options[:authority]
  #   generate_uri
  #   
  #   self.comment = options[:comment] if options.include?(:comment)
  #   self.tags = options[:tags] if options.include?(:tags)
  #   self.range = options[:range] if options.include?(:range)
  #   self.deprecated = options[:deprecated] if options.include?(:deprecated)
  #   self.expected_type = options[:expected_type] if options.include?(:expected_type)
  #   self.enumerations = options[:enumerations] if options.include?(:enumerations)
  # end
  
  # Property Name in Compact URI form => "foaf:name"
  def curie
    self.namespace['subdomain'] + ':' + self.term
  end
  
private
  def generate_uri
    self.term = escape_string(self.label)
    rdf_uri = RDF::URI.new('http://civicopenmedia.us')/self.subdomain/"terms#"/self.term
    self.uri = rdf_uri.to_s
  end

  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.authority + '_' +
                         self.term if new?
  end

  def escape_string(str)
    str.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') 
  end

end