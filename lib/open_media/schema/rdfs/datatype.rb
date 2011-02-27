module OpenMedia
  module Schema
    module RDFS
      class Datatype
        include Spira::Resource
        default_source 'types'
        type ::RDF::RDFS.Datatype
      end
    end
  end
end
