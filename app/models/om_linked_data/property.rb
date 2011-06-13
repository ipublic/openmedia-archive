class OmLinkedData::Property < CouchRest::Model::Base

  use_database TYPES_DATABASE
  unique_id :identifier

  property :identifier, :init_method => 'new'
  property :label, String                             # User assigned name, RDFS#Label
  property :comment, String                           # => RDFS#Comment
  property :tags, [String]

  property :base_uri, String
  property :subdomain, String
  property :uri, String
  property :term, String                              # Escaped vocabulary name suitable for inclusion in IRI
  property :authority, String

#  property :range                                     # => RDFS.range
  property :expected_type, OmLinkedData::Type     # Support type coercion
  
  property :deprecated, TrueClass, :default => false  # Deprecated propoerties may not be used 
                                                       # for future vocabularies
                                                      
  property :enumerations                               # Hash of key/value lookups
  
  collection_of :synonyms, :class_name => 'OmLinkedData::Property'  # Props with same semantic meaning
  
  timestamps!

  validates_presence_of :label
  validates_presence_of :base_uri
  validates_uniqueness_of :identifier, :view => 'all'
  
  before_create :generate_uri
  before_create :generate_identifier
  
  view_by :label
  view_by :authority
  view_by :base_uri

  view_by :tags,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'OmLinkedData::Property' && doc.tags) {
          doc.tags.forEach(function(tag) {
            emit(tag, 1); 
            });
          }
        }"

  # Property Name in Compact URI form => "foaf:name"
  def curie
    self.namespace['subdomain'] + ':' + self.term
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

    rdf_uri = RDF::URI.new('http://civicopenmedia.us')/self.subdomain/"terms#"/self.term
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