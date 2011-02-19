class OpenMedia::Schema::OWL::ObjectProperty < OpenMedia::Schema::RDF::Property
  type OWL.ObjectProperty

  property :domain, :predicate=>RDFS.domain, :type=>:'OpenMedia::Schema::OWL::Class'

  def self.create_in_class!(owl_class, data)
    identifier = data[:label].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
    p = self.for(owl_class.uri/"##{identifier}", data.merge(:domain=>owl_class))
    p.save!
    p
  end  
end
