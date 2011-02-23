class OpenMedia::Schema::OWL::DatatypeProperty < OpenMedia::Schema::RDF::Property
  type OWL.DatatypeProperty

  property :domain, :predicate=>RDFS.domain, :type=>:'OpenMedia::Schema::OWL::Class'  

  def self.create_in_class!(owl_class, data, uri=nil)
    unless uri
      identifier = data[:label].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
      uri = owl_class.uri/"##{identifier}"
    end
    p = self.for(uri, data.merge(:domain=>owl_class))
    p.save!
    p
  end  
end
