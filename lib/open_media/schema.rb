require 'spira'
require 'spira/resource'
require 'spira/types'

# Define vocabularies not built-in
RDF::OM_DATA = RDF::Vocabulary.new('http://data.civicopenmedia.org/')
RDF::OM_CORE = RDF::Vocabulary.new(RDF::OM_DATA['core/'])
RDF::VCARD = RDF::Vocabulary.new(RDF::OM_CORE['vcard/'])

require 'open_media/schema/types'
require 'open_media/schema/base'
require 'open_media/schema/rdf/property'
require 'open_media/schema/rdfs/class'
require 'open_media/schema/rdfs/datatype'
require 'open_media/schema/owl/datatype_property'
require 'open_media/schema/owl/object_property'
require 'open_media/schema/owl/class'
require 'open_media/schema/skos/concept'
require 'open_media/schema/skos/collection'

# save current types, then overload settings method so it is not a thread local anymore
spira_types = Spira.types
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
Spira.settings[:types] = spira_types
