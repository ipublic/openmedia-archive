require 'linkeddata'
require 'rdf/couchdb'
require 'spira'

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
Spira.add_repository! :types, TYPES_RDF_REPOSITORY

