class OpenMedia::Schema::Domain < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  
  property :name
  property :identifier
  property :hidden, :default => false
  
  property :creator
  property :permission
  
  timestamps!

  validates :name, :presence => true, :uniqueness => true
  validates :identifier, :presence => true, :uniqueness => true

  belongs_to :site, :class_name=>'OpenMedia::Site'
  
  ## Views
  view_by :site_id

  # These are custom views because by default, couchrest won't emit docs with null keys
  view_by :site_id,
    :map =>
      "function(doc) {
         if (doc['couchrest-type'] == 'OpenMedia::Schema::Domain') {         
	   emit(doc.site_id); 
         }
      }"
  
  
  view_by :site_id, :identifier,
    :map =>
      "function(doc) {
         if (doc['couchrest-type'] == 'OpenMedia::Schema::Domain') {         
	   emit(doc.site_id, doc.identifier); 
         }
      }"
  
  view_by :name  
  
  ## Callbacks
  before_save :create_database

  def self.default_types
    self.find_by_site_id_and_identifier(nil, 'types')
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

  def types
    OpenMedia::Schema::Type.by_domain_id(:key => self.id)
  end


  def qualified_name
    [self.site ? self.site.identifier : nil, self.identifier].compact.join('/')
  end


private

  def generate_identifier
    return if self.name.nil? || self.name.empty?

    # ID is form <name_space>_<name> where name is only lower case alpha & numeric characters
    self.identifier = self.name.downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
    create_database
  end
  
  def create_database
    db_name = self.site ? "#{self.site.identifier}_#{self.identifier}" : self.identifier
    COUCHDB_SERVER.define_available_database(db_name.to_sym, db_name) 
  end  
end
