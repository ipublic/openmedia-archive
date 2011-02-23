# Create simplified VCard schema

# VCard#Address
address = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Address).save!
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(address, {:label=>'Street Address', :range=>RDF::XSD.string}, RDF::VCARD['street-address'])
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(address, {:label=>'Extended Address', :range=>RDF::XSD.string}, RDF::VCARD['extended-address'])
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(address, {:label=>'Post Office Box', :range=>RDF::XSD.string}, RDF::VCARD['post-office-box'])
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(address, {:label=>'Locality', :range=>RDF::XSD.string}, RDF::VCARD.locality)
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(address, {:label=>'Region', :range=>RDF::XSD.string}, RDF::VCARD.region)
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(address, {:label=>'Postal Code', :range=>RDF::XSD.string}, RDF::VCARD['postal-code'])
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(address, {:label=>'Country Name', :range=>RDF::XSD.string}, RDF::VCARD['country-name'])
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(address, {:label=>'Type', :range=>RDF::OWL.Class}, RDF.type)

tel = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Tel).save!
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(tel, {:label=>'Value', :range=>RDF::XSD.string}, RDF.value)
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(tel, {:label=>'Type', :range=>RDF::OWL.Class}, RDF.type)

email = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Email).save!
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(email, {:label=>'Value', :range=>RDF::XSD.string}, RDF.value)
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(email, {:label=>'Type', :range=>RDF::OWL.Class}, RDF.type)

name = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Name).save!
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(name, {:label=>'Honorific Prefix', :range=>RDF::XSD.string}, RDF::VCARD['honorific-prefix'])
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(name, {:label=>'Given Name', :range=>RDF::XSD.string}, RDF::VCARD['given-name'])
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(name, {:label=>'Family Name', :range=>RDF::XSD.string}, RDF::VCARD['family-name'])
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(name, {:label=>'Additional Name', :range=>RDF::XSD.string}, RDF::VCARD['additional-name'])
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(name, {:label=>'Honorific Suffix', :range=>RDF::XSD.string}, RDF::VCARD['honorific-suffix'])

org = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Organization).save!
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(org, {:label=>'Organization Name', :range=>RDF::XSD.string}, RDF::VCARD['organization-name'])
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(org, {:label=>'Organization Unit', :range=>RDF::XSD.string}, RDF::VCARD['organization-unit'])

vcard = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).save!
OpenMedia::Schema::OWL::ObjectProperty.create_in_class!(vcard, {:label=>'Name', :range=>RDF::VCARD.Name}, RDF::VCARD.n)
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(vcard, {:label=>'Title', :range=>RDF::XSD.string}, RDF::VCARD.title)
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(vcard, {:label=>'Role', :range=>RDF::XSD.string}, RDF::VCARD.role)
OpenMedia::Schema::OWL::ObjectProperty.create_in_class!(vcard, {:label=>'Organization', :range=>RDF::VCARD.Organization}, RDF::VCARD.org)
OpenMedia::Schema::OWL::ObjectProperty.create_in_class!(vcard, {:label=>'Address', :range=>RDF::VCARD.Address}, RDF::VCARD.adr)
OpenMedia::Schema::OWL::ObjectProperty.create_in_class!(vcard, {:label=>'Phone', :range=>RDF::VCARD.Tel}, RDF::VCARD.tel)
OpenMedia::Schema::OWL::ObjectProperty.create_in_class!(vcard, {:label=>'Email', :range=>RDF::VCARD.Email}, RDF::VCARD.email)
OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(vcard, {:label=>'Note', :range=>RDF::XSD.string}, RDF::VCARD.note)
