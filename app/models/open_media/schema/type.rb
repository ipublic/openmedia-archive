class OpenMedia::Schema::Type < CouchRest::Model::Base

  use_database TYPES_DATABASE
  unique_id :key
  
  belongs_to :domain, :class_name => 'OpenMedia::Schema::Domain'

  property :name
  property :key
  property :description
  
#  collection_of :property_list, :class_name => 'OpenMedia::Schema::Property'
#  property :included_types, ['OpenMedia::Schema::Type']
  
  property :creator
  property :permission
  
  timestamps!
  
  validates_presence_of :key
  validates_uniqueness_of :key, :view => 'all'
  validates :name, :presence => true
  validates :domain_id, :presence => true # property auto-geneated by belongs_to association
  
  ## Views
  view_by :name
  view_by :creator
  view_by :domain_id
  
  ## Callbacks
  before_save :generate_key
  
  def property_count
    type_properties = OpenMedia::Schema::Property.by_type_id(:key => self.key)
    count = type_properties.nil? ? 0 : type_properties.count
  end

  
  
private

  def generate_key
    self['key'] = self.domain.web_address.gsub(/#/,'/') + '#' + self['key'] if new?
  end

  
end