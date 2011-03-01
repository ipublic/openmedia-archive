module OpenMedia
  module Schema
    module VCard
      def self.configure_vcard
        begin
          OpenMedia::Site.instance
          [::RDF::VCARD.VCard, ::RDF::VCARD.Name, ::RDF::VCARD.Organization, ::RDF::VCARD.Email, ::RDF::VCARD.Tel, ::RDF::VCARD.Address].each do |uri|
            cls = OpenMedia::Schema::OWL::Class.for(uri).spira_resource
            cls.base_uri(::RDF::OM_DATA)
            cls.default_source(OpenMedia::Site.instance.metadata_repository)
          end
        rescue Exception => e
        end
      end    
    end
  end
end
