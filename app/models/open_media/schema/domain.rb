class OpenMedia::Schema::Domain < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  unique_id :web_address
  
  property :name
  property :web_address
  property :hidden
  
  property :creator
  property :permission
  
  timestamps!

  validates :name, :presence => true, :uniqueness => true
  validates :web_address, :presence => true, :uniqueness => true

  ## Views
  view_by :name
  view_by :creator
  
  ## Callbacks
  before_save :generate_identifier

  def type_count
    domain_types = OpenMedia::Schema::Type.by_domain_id(:key => self.web_address)
    count = domain_types.nil? ? 0 : domain_types.count
  end

private

  def generate_identifier
#    self['web_address'] = '/' + self.database.name + '/' + self['web_address'] if new?
    self['web_address'] = self['web_address'] if new?
  end
  
end
