module OpenMedia
  module Schema
    module Metadata
      def self.configure_metadata
        begin
          metadata_model = OpenMedia::Schema::RDFS::Class.for(::RDF::METADATA.Metadata).spira_resource
          metadata_model.default_source(OpenMedia::Site.instance.metadata_repository)
        rescue Exception => e          
        end
      end
    end
  end
end
  
