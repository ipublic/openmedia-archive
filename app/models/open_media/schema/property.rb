class OpenMedia::Schema::Property < Hash

  include CouchRest::Model::CastedModel  
  
  belongs_to :expected_type, :class_name => 'OpenMedia::Schema::Type'
  
  property :name
  property :identifier
  property :description

  property :disambiguating, :default => false
  property :unique, :default => false
  property :hidden, :default => false
  property :master_or_delegated, :default => 'master'

  property :permission
  
  timestamps!

  validates :name, :presence => true
  validates :expected_type_id, :presence => true

  def name=(name)
    self['name'] = name
    generate_identifier
  end

  def path
    if self.casted_by.instance_of?(OpenMedia::Schema::Type)
      [self.casted_by.path, self.identifier].join('#')
    end
  end

  def uri
    if self.casted_by.instance_of?(OpenMedia::Schema::Type)
      "http://openmedia.org#{path}"
    end
  end


private

  def generate_identifier
    return if self.name.nil? || self.name.empty?

    # ID is form <name_space>_<name> where name is only lower case alpha & numeric characters
    self.identifier = self.name.downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
  end
    
end
