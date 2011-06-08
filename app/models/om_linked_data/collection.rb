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
  property :uri, String
  property :term, String                 # Escaped vocabulary name suitable for inclusion in IRI
  property :authority, String

  timestamps!

  validates_presence_of :label
  validates_presence_of :base_uri
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

private
  def generate_uri
  
    # base_uri => "http://dcgov.civicopenmedia.us"
    parts = base_uri.split('.')
    self.subdomain = parts.first.split("http://").last
    domain = base_uri.split(subdomain + '.').last.gsub('.','_')

    # authority => "civicopenmedia_us_dcgov"
    self.authority = domain + '_' + subdomain
    self.term = escape_string(self.label)

    rdf_uri = RDF::URI.new('http://civicopenmedia.us')/self.subdomain/"collections#"/self.term
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