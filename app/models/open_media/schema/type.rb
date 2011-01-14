class OpenMedia::Schema::Type < CouchRest::Model::Base

  use_database TYPES_DATABASE
  
  belongs_to :domain, :class_name => 'OpenMedia::Schema::Domain'

  property :name
  property :identifier
  property :description
  property :type_properties, [OpenMedia::Schema::Property]
    
  property :creator
  property :permission
  
  timestamps!
  
  validates_presence_of :identifier
  validates_uniqueness_of :identifier, :view => 'all'
  validates :name, :presence => true
  validates :domain, :presence => true # property auto-geneated by belongs_to association
  
  ## Views
  view_by :creator
  view_by :domain_id
  view_by :identifier

  def name=(name)
    self['name'] = name
    generate_identifier
  end
  
  def qualified_name
    [self.domain.qualified_name, self.identifier].join('/')
  end
  
private
  def generate_identifier
    return if self.name.nil? || self.name.empty?
    self.identifier = self.name.downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'')
  end
  
end
