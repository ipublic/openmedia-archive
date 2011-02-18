# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

dan = OpenMedia::Contact.create!(:first_name => 'Dan',
                            :last_name => 'Thomas',
                            :job_title => 'Chief Technology Officer',
                            :email => 'dan.thomas@ipublic.org')

dans_address = OpenMedia::Address.new(:city => 'Ellicott City',
                             :state_abbreviation => 'MD',
                             :zipcode => '21043',
                             :address_type => 'Business')
OpenMedia::Organization.create!({
  :name => 'iPublic, LLC', 
  :abbreviation => 'ipublic',
  :contacts => [dan],
  :addresses => [dans_address],
  :website_url => 'http://www.ipublic.org',
  :note => 'iPublic is creator and maintainer of Civic OpenMedia system'
  }
)

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
