class OpenMedia::Schema::SKOS::Concept
  include Spira::Resource
  
  default_source :types
  base_uri "http://data.civicopenmedia.org/"
  type SKOS.Concept

  def rdfs_class
    OpenMedia::Schema::RDFS::Class.for(self.uri)
  end

  def collection
    unless @collection
      r = self.class.repository.query(:object=>self.uri, :predicate=>SKOS.member)
      @collection = OpenMedia::Schema::SKOS::Collection.for(r.first.subject) if r.first      
    end
    @collection
  end
end

