class OpenMedia::Schema::RDFS::Class
  include Spira::Resource
  
  default_source :types
  base_uri "http://data.openmedia.org/"
  type RDFS.Class

  property :label, :predicate=>RDFS.label, :type=>XSD.string
  property :comment, :predicate=>RDFS.comment, :type=>XSD.string
  has_many :properties, :predicate=>RDF.Property, :type=>:'OpenMedia::Schema::RDF::Property'

  def self.create_in_site!(site, data)
    identifier = data[:label].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
    c = self.for("#{site.identifier}/classes/#{identifier}", data)
    c.save!
    self.repository_or_fail.insert(RDF::Statement.new(c.subject, RDF.type, RDF::SKOS.Concept))
    c    
  end

end



