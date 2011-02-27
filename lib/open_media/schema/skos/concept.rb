module OpenMedia
  module Schema
    module SKOS
      class Concept
        include Spira::Resource
        
        default_source 'types'
        type ::RDF::SKOS.Concept

        def rdfs_class
          OpenMedia::Schema::RDFS::Class.for(self.uri)
        end

        def collection
          unless @collection
            r = self.class.repository.query(:object=>self.uri, :predicate=>::RDF::SKOS.member)
            @collection = OpenMedia::Schema::SKOS::Collection.for(r.first.subject) if r.first      
          end
          @collection
        end
      end
    end
  end
end
