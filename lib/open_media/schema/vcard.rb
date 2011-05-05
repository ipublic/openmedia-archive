module OpenMedia
  module Schema
    module VCard
      def self.initialize_vcard
        [::RDF::VCARD.VCard, ::RDF::VCARD.Name, ::RDF::VCARD.Organization, ::RDF::VCARD.Email, ::RDF::VCARD.Tel, ::RDF::VCARD.Address].each do |uri|
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
