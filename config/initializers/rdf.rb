require 'linkeddata'
require 'rdf/couchdb'
require 'spira'

# Define vocabularies not built-in
RDF::OM_CORE = RDF::Vocabulary.new('http://data.civicopenmedia.org/core/')
RDF::VCARD = RDF::Vocabulary.new(RDF::OM_CORE['vcard/'])

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

TYPES_RDF_REPOSITORY = RDF::CouchDB::Repository.new(:database=>TYPES_DATABASE)
SITE_RDF_REPOSITORY = RDF::CouchDB::Repository.new(:database=>SITE_DATABASE)
Spira.add_repository! 'types', TYPES_RDF_REPOSITORY
OpenMedia::Schema::RDFS::Class.refresh_design_doc
#OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource.default_source())
