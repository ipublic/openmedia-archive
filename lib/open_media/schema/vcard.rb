module OpenMedia
  module Schema
    module VCard
      VCARD_MODEL_URIS = [::RDF::VCARD.VCard, ::RDF::VCARD.Name, ::RDF::VCARD.Organization, ::RDF::VCARD.Email, ::RDF::VCARD.Tel, ::RDF::VCARD.Address]
      
      def self.reset_vcard
        VCARD_MODEL_URIS.each do |uri|
          class_name = OpenMedia::Schema::OWL::Class.for(uri).spira_class_name
          begin
            OpenMedia::Schema::OWL::Class.send(:remove_const, class_name.split('::').last.to_sym)
          rescue => e
          end
        end
      end
      
      def self.initialize_vcard
        reset_vcard
        VCARD_MODEL_URIS.each do |uri|
          cls = OpenMedia::Schema::OWL::Class.for(uri).spira_resource
        end
      end

      def self.configure_vcard(site)
        begin
          [::RDF::VCARD.VCard, ::RDF::VCARD.Name, ::RDF::VCARD.Organization, ::RDF::VCARD.Email, ::RDF::VCARD.Tel, ::RDF::VCARD.Address].each do |uri|
            cls = OpenMedia::Schema::OWL::Class.for(uri).spira_resource
            cls.base_uri(::RDF::OM_DATA)
            cls.default_source(site.metadata_repository)
          end
        rescue Exception => e
        end
      end    
    end
  end
end
