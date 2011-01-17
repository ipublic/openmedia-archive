class OpenMedia::Schema::Domain < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  
  property :name_space
  property :name
  property :identifier
  property :hidden, :default => false
  
  property :creator
  property :permission
  
  timestamps!

  validates :name, :presence => true, :uniqueness => true
  validates :identifier, :presence => true, :uniqueness => true

  ## Views
  view_by :name_space
  view_by :name_space, :identifier  
  view_by :name  
  
  ## Callbacks
  before_save :create_database

  def self.default_types
    self.find_by_name_space_and_identifier(['','types'])
  end

  def name=(name)
    self['name'] = name
    generate_identifier
  end

  def find_type(type_identifier)
    OpenMedia::Schema::Type.find_by_domain_id_and_identifier(:key=>[self.id,type_identifier])
  end


  def type_count
    domain_types = OpenMedia::Schema::Type.by_domain_id(:key => self.id, :raw=>true)
    count = domain_types['rows'].length
  end

  def qualified_name
    self.name_space.blank? ? self.identifier : [self.name_space, self.identifier].join('/')
  end


private

  def generate_identifier
    return if self.name.nil? || self.name.empty?

    # ID is form <name_space>_<name> where name is only lower case alpha & numeric characters
    self.identifier = self.name.downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'')
    create_database
  end
  
  def create_database
#    COUCHDB_SERVER.database().create!
    COUCHDB_SERVER.define_available_database("#{self.name_space}_#{self.identifier}".to_sym, "#{self.name_space}_#{self.identifier}") 
  end

  
end
