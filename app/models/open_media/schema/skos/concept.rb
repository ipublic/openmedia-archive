class OpenMedia::Schema::SKOS::Concept < OpenMedia::Schema::Base
  
  default_source :types
  base_uri "http://data.openmedia.org/"
  type SKOS.Concept

  def rdfs_class
    OpenMedia::Schema::RDFS::Class.for(self.uri)
  end

end

