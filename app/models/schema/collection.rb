class Schema::Collection < CouchRest::Model::Base

  use_database TYPES_DATABASE
  unique_id :identifier
  
  belongs_to :namespace, :class_name => "Schema::Namespace"

  property :identifier, String
  property :label, String       # User assigned name, RDFS#Label
  property :comment, String     # RDFS#Comment
  property :tags, [String]

  timestamps!

  validates_presence_of :label, :namespace_id
  validates_uniqueness_of :identifier, :view => 'all'

  ## Callbacks
  before_create :generate_identifier

  view_by :label
  view_by :namespace_id
  
  view_by :tags,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'Schema::Collection' && doc.tags) {
          doc.tags.forEach(function(tag) {
            emit(tag, 1); 
            });
          }
        }"

  ##
  # Returns the Collections for passed Namespace.
  #
  # @return [Collection]  
  def self.find_by_namespace_id(ns_id)
    self.by_namespace_id(:key => ns_id)
  end
      
private
  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.namespace.authority_uri + '_' +
                         label.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end

end