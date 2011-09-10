# require 'linkeddata'
require 'rdf/couchdb'
# require 'spira'
# require 'open_media/schema'
# 
# module Spira
#  def settings
#    $SPIRA_SETTINGS ||= {}
#  end
#  module_function :settings
# 
#  class Errors
#    def count
#      @errors.size
#    end
# 
#    def full_messages
#      messages = []
#      @errors.each {|k,v| messages << v}
#      messages.flatten!
#    end
# 
#    def [](field)
#      @errors[field.to_sym] || []
#    end
#  end
# end
# 
# TYPES_RDF_REPOSITORY = RDF::CouchDB::Repository.new(:database=>TYPES_DATABASE)
# Spira.add_repository! 'types', TYPES_RDF_REPOSITORY
# 
begin
  # Define vocabularies not built-in
  RDF::OM_DATA = RDF::Vocabulary.new('http://data.civicopenmedia.org/')
  RDF::OM_CORE = RDF::Vocabulary.new(RDF::OM_DATA['core/'])
  RDF::DCTYPE = RDF::Vocabulary.new('http://purl.org/dc/dcmitype/')
  RDF::VCARD = RDF::Vocabulary.new(RDF::OM_CORE['vcard/'])
  RDF::METADATA = RDF::Vocabulary.new(RDF::OM_CORE['metadata/'])
  
  
#   OpenMedia::Schema::DesignDoc.refresh
# 
#   OpenMedia::Schema::RDFS::Class.for(::RDF::METADATA.Metadata)
#   OpenMedia::Schema::OWL::Class.for(::RDF::VCARD.VCard)
# 
#   # setup vcard models
#   OpenMedia::Schema::VCard.initialize_vcard
# 
#   
#   # setup metadata model
#   OpenMedia::Schema::Metadata.initialize_metadata
# rescue => e
#   puts e.inspect
end
# 
