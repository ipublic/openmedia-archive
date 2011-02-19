class OpenMedia::Schema::OWL::DatatypeProperty < OpenMedia::Schema::RDF::Property
  type OWL.DatatypeProperty

  property :domain, :predicate=>RDFS.domain, :type=>:'OpenMedia::Schema::OWL::Class'  

  def self.create_in_class!(rdfs_class, data)
    identifier = data[:label].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
    p = self.for(rdfs_class.uri/"##{identifier}", data.merge(:domain=>rdfs_class))
    p.save!
    p
  end  
end
