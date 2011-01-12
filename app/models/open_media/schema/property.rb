class OpenMedia::Schema::Property < Hash

  include CouchRest::Model::CastedModel  
  
  belongs_to :type, :class_name => 'OpenMedia::Schema::Type'
  belongs_to :expected_type, :class_name => 'OpenMedia::Schema::Type'
  
  property :name
  property :description

  property :disambiguating, :default => false
  property :unique, :default => false
  property :hidden, :default => false
  property :master_or_delegated, :default => 'master'
  
  property :creator
  property :permission
  
  timestamps!

  validates :name, :presence => true
  validates :expected_type_id, :presence => true
  validates :type_id, :presence => true
    
end
