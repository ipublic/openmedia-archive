class Schema::Collection < CouchRest::Model::Base

  use_database TYPES_DATABASE
  unique_id :identifier

  property :identifier
  property :namespace, Schema::Namespace
  property :comment, String    # RDFS#Comment

  property :label, String       # User assigned name, RDFS#Label
  property :tags, [String]

  timestamps!

  validates_presence_of :label, :namespace
  validates_uniqueness_of :identifier, :view => 'all'

  ## Callbacks
  before_create :generate_identifier

  view_by :label
  view_by :tags,
    :map =>
      "function(doc) {
        if (doc['couchrest-type'] == 'Schema::Collection' && doc.tags) {
          doc.tags.forEach(function(tag){
            emit(doc.tag, 1);
          });
        }
      }",
    :reduce =>
      "function(keys, values, rereduce) {
        return sum(values);
      }"
    view_by :iri_base,
      :map => 
        "function(doc) {
          if ((doc['couchrest-type'] == 'Schema::Collection') && 
              (doc.namespace['iri_base'] != null))  
          { emit(doc.namespace['iri_base'], null);}}"

private
  def generate_identifier
    self['identifier'] = self.class.to_s.downcase + '_' + label.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end

end