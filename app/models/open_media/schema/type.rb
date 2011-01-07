class OpenMedia::Schema::Type < CouchRest::Model::Base

  use_database TYPES_DATABASE
  
  belongs_to :domain, :class_name => 'OpenMedia::Schema::Domain'

  property :name
  property :identifier
  property :description
  
#  collection_of :property_list, :class_name => 'OpenMedia::Schema::Property'
#  property :included_types, ['OpenMedia::Schema::Type']
  
  property :creator
  property :permission
  
  timestamps!
  
  validates_presence_of :identifier
  validates_uniqueness_of :identifer, :view => 'all'
  validates :name, :presence => true
  validates :domain_id, :presence => true # property auto-geneated by belongs_to association
  
  ## Views
  view_by :creator
  view_by :domain_id
  view_by :identifier  

  def name=(name)
    self['name'] = name
    generate_identifier
  end
  
  def property_count
    type_properties = OpenMedia::Schema::Property.by_type_id(:key => self.key)
    count = type_properties.nil? ? 0 : type_properties.count
  end

private
  def generate_identifier
    return if self.name.nil? || self.name.empty?
    self.identifier = self.name.downcase.gsub(/[^a-z0-9]/,'').gsub(/^\-|\-$/,'')
  end
  
end
