class OpenMedia::DatasourceProperty < Hash

  include CouchRest::Model::CastedModel

  property :label
  property :identifier
  property :comment
  property :range_uri

  timestamps!

  validates :label, :presence => true
  validates :range_uri, :presence => true

  def label=(label)
    self['label'] = label
    generate_identifier
  end

private

  def generate_identifier
    return if self.label.nil? || self.label.empty?
    self.identifier = self.label.downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
  end
    
end
