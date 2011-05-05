# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Create RDF Statements defining core XSD types OpenMedia will use
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.base64Binary).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.boolean).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.byte).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.date).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.dateTime).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.double).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.duration).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.float).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.integer).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.long).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.short).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.string).save!
OpenMedia::Schema::RDFS::Datatype.for(RDF::XSD.time).save!

# create datatype for JSON
OpenMedia::Schema::RDFS::Datatype.for(RDF::OM_CORE.GeoJson).save!

# TYPES_RDF_REPOSITORY.load('http://www.w3.org/2006/vcard/ns');
TYPES_RDF_REPOSITORY.refresh_design_doc   # just in case

OpenMedia::Schema::VCard.initialize_vcard
OpenMedia::Schema::Metadata.initialize_metadata

require File.join(File.dirname(__FILE__),'seeds', 'metadata')
require File.join(File.dirname(__FILE__),'seeds', 'vcard')

# create om site w/ dan as admin
ec = OpenMedia::InferenceRules::GeographicName.find_by_name('Ellicott City').first
om_site = OpenMedia::Site.create!(:identifier=>"om", :municipality=>ec, :openmedia_name=>'iPublic OpenMedia Portal')
om_site.initialize_metadata

dan = Admin.create!(:email=>'dan.thomas@ipublic.org', :password=>'ChangeMe',
                    :password_confirmation=>'ChangeMe', :site=>om_site, :confirmed_at=>Time.now)

name = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardName.new(:given_name=>'Dan', :family_name=>'Thomas').save!
email = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardEmail.new(:value=>'dan.thomas@ipublic.org', :type=>RDF::VCARD.Work.to_s).save!
vcard = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(om_site.vcards_rdf_uri/UUID.new.generate.gsub(/-/,''))
vcard.n = name
vcard.email = email
vcard.save!

## Initialize the Commons Collections
collections = [
  'Arts', 'Animal Control', 'Agriculture',
  'Banking, Finance and Insurance',
  'Business',
  'Census',
  'Economy', 'Elections', 'Education', 'Environment',
  'Government',
  'Health', 'Human Services',
  'Justice',
  'Licensing', 'Labor Force',
  'Military',
  'Natural Resources',
  'Parks and Recreation', 'People', 'Physical Geography', 'Planning', 'Property', 'Public Safety', 'Public Works',
  'Science', 
  'Technology and Communication', 'Transportation',
  'Utilities',
  'Weather'
  ]

collections.sort.each { |col| OpenMedia::Schema::SKOS::Collection.create_in_collection!(om_site.skos_collection, :label=> col)}
