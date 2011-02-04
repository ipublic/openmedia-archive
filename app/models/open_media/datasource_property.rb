class OpenMedia::DatasourceProperty < Hash

  include CouchRest::Model::CastedModel

  property :name
  property :identifier
  property :description
  property :rdfs_type_uri

  timestamps!

  validates :label, :presence => true
  validates :rdfs_type_uri, :presence => true

  def name=(name)
    self['name'] = name
    generate_identifier
  end

private

  def generate_identifier
    return if self.name.nil? || self.name.empty?
    self.identifier = self.name.downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
  end
    
end
