module OpenMedia::Schema::Types

  class OpenMedia::Schema::DateTime
    include Spira::Type

    def self.unserialize(value)
      value.object
    end

    def self.serialize(value)
      RDF::Literal::DateTime.new(value) if value
    end
    
    register_alias XSD.dateTime
  end
  
end
