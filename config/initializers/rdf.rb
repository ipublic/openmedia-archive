require 'linkeddata'
require 'rdf/couchdb'

TYPES_RDF_REPOSITORY = RDF::CouchDB::Repository.new(:database=>TYPES_DATABASE)
Spira.add_repository! :types, TYPES_RDF_REPOSITORY
