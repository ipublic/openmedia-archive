class OpenMedia::DatasourceProperty < Hash

  include CouchRest::Model::CastedModel

  property :label
  property :identifier
  property :comment
  property :range_uri
  property :rdf_property_uri

  timestamps!

  validates :label, :presence => true
  validates :range_uri, :presence => true

  def label=(label)
    self['label'] = label
    generate_identifier
  end

  def range
    RDF::URI.new(self.range_uri) if self.range_uri
  end

  def rdf_property
    OpenMedia::Schema::RDF::Property.for(self.rdf_property_uri) if self.rdf_property_uri
  end
  

private

  def generate_identifier
    return if self.label.nil? || self.label.empty?
    self.identifier = self.label.downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
  end
    
end
