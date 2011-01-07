class OpenMedia::Schema::Domain < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  unique_id :identifier
  
  property :namespace
  property :name
  property :identifier
  property :hidden, :default => false
  
  property :creator
  property :permission
  
  timestamps!

  validates_presence_of :namespace
  validates :name, :presence => true, :uniqueness => true
  validates :identifier, :presence => true, :uniqueness => true

  ## Views
  view_by :namespace
  view_by :name
  
  ## Callbacks
  before_save :create_database
  
  def namespace=(namespace)
    self['namespace'] = namespace
    generate_identifier
  end
  
  def name=(name)
    self['name'] = name
    generate_identifier
  end

  def type_count
    domain_types = OpenMedia::Schema::Type.by_domain_id(:key => self.identifier)
    count = domain_types.nil? ? 0 : domain_types.count
  end

private

  def generate_identifier
    return if self.namespace.nil? || self.namespace.empty?
    return if self.name.nil? || self.name.empty?

    # ID is form <namespace>_<name> where name is only lower case alpha & numeric characters
    self.identifier = self.namespace + "_" + self.name.downcase.gsub(/[^a-z0-9]/,'').gsub(/^\-|\-$/,'')
    create_database
  end
  
  def create_database
#    COUCHDB_SERVER.database().create! 
    COUCHDB_SERVER.define_available_database(self.identifier.to_sym, self.identifier) 
  end

  
end
