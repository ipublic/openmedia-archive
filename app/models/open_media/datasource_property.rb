class OpenMedia::DatasourceProperty < Hash

  INTEGER_REGEX = /^[-+]?\d+$/
  FLOAT_REGEX = /^[-+]?[0-9]*\.[0-9]+$/
  
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

  def set_range_from_csv_value(data)
    if data =~ INTEGER_REGEX
      self.range_uri = RDF::XSD.integer.to_s
    elsif data =~ FLOAT_REGEX
      self.range_uri = RDF::XSD.float.to_s      
    else
      self.range_uri = RDF::XSD.string.to_s      
    end
  end

  

private

  def generate_identifier
    return if self.label.nil? || self.label.empty?
    self.identifier = self.label.downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
  end
    
end
