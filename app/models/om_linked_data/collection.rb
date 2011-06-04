class OmLinkedData::Collection < CouchRest::Model::Base

  use_database TYPES_DATABASE
  unique_id :identifier
  
  property :identifier, String
  property :label, String       # User assigned name, RDFS#Label
  property :comment, String     # RDFS#Comment
  property :tags, [String]
  property :hidden, TrueClass, :default => false
  property :authority, String
  property :namespace, OmLinkedData::Namespace

  timestamps!

  validates_presence_of :label, :authority
  validates_uniqueness_of :identifier, :view => 'all'

  ## Callbacks
  before_create :generate_identifier
#  before_create :get_authority

  view_by :label
  view_by :authority
  
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
  def generate_identifier
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.authority + '_' +
                         label.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
  # def get_authority
  #   if self["authority"].nil?
  #     ns = OmLinkedData::Namespace.new
  #     self['authority'] = ns.authority
  #   end
  # end

end