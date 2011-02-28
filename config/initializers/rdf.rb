require 'linkeddata'
require 'rdf/couchdb'
require 'spira'
require 'open_media/schema'

TYPES_RDF_REPOSITORY = RDF::CouchDB::Repository.new(:database=>TYPES_DATABASE)
SITE_RDF_REPOSITORY = RDF::CouchDB::Repository.new(:database=>SITE_DATABASE)
Spira.add_repository! 'types', TYPES_RDF_REPOSITORY

#OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource.default_source())


OpenMedia::Schema::RDFS::Class.refresh_design_doc

module Spira
 def settings
   $SPIRA_SETTINGS ||= {}
 end
 module_function :settings

 class Errors
   def count
     @errors.size
   end

   def full_messages
     messages = []
     @errors.each {|k,v| messages << v}
     messages.flatten!
   end

   def [](field)
     @errors[field.to_sym] || []
   end
 end
end

# setup vcard models
module OpenMedia
  module Schema
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

OpenMedia::Schema.configure_vcard

