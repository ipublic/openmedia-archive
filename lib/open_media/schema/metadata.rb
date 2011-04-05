module OpenMedia
  module Schema
    module Metadata

      def self.initialize_metadata
        metadata_model = OpenMedia::Schema::RDFS::Class.for(::RDF::METADATA.Metadata).spira_resource        
      end

      def self.configure_metadata(site)
        begin
          metadata_model = OpenMedia::Schema::RDFS::Class.for(::RDF::METADATA.Metadata).spira_resource
          metadata_model.default_source(site.metadata_repository)
        rescue Exception => e          
        end
      end
    end
  end
end
  
