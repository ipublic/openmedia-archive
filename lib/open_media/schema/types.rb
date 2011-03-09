module OpenMedia
  module Schema
    class DateTime
      include Spira::Type

      def self.unserialize(value)
        value.object
      end

      def self.serialize(value)
        ::RDF::Literal::DateTime.new(value) if value
      end
      
      register_alias XSD.dateTime
    end

    class JSON
      include Spira::Type

      def self.unserialize(value)
        ::JSON.parse(value.object)
      end

      def self.serialize(value)
        ::RDF::Literal.new(::JSON.generate(value), :datatype=>OM_CORE.GeoJson) if value
      end
      
      register_alias OM_CORE.GeoJson
    end      
    
  end
end
