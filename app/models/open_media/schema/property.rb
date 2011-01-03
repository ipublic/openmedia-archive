class OpenMedia::Schema::Property < CouchRest::Model::Base

  use_database TYPES_DATABASE
  unique_id :key
  
  belongs_to :type, :class_name => 'OpenMedia::Schema::Type'
  belongs_to :expected_type, :class_name => 'OpenMedia::Schema::Type'
  
  property :name
  property :key
  property :description

  property :disambiguating, :default => false
  property :unique, :default => false
  property :hidden, :default => false
  property :master_or_delegated, :default => 'master'
  
  property :creator
  property :permission
  
  timestamps!

  validates :name, :presence => true
  validates :key, :presence => true, :uniqueness => true
  validates :expected_type_id, :presence => true
  validates :type_id, :presence => true
  
  ## Views
  view_by :name
  view_by :creator
  view_by :type_id
  
  ## Callbacks
  before_save :generate_key

private

  def generate_key
    self['key'] = self.type.key.web_address.gsub(/#/,'/') + '#' + self['key'] if new?
  end
  
end
