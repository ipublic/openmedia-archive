# Create openmedia rdf metadata class
metadata = OpenMedia::Schema::RDFS::Class.for(RDF::METADATA.Metadata, :label=>'Metadata', :comment=>'Resource containing metadata for a set of records').save!
OpenMedia::Schema::RDF::Property.create_in_class!(metadata, {:label=>'Creator', :range=>::RDF::VCARD.VCard}, RDF::DC.creator)
OpenMedia::Schema::RDF::Property.create_in_class!(metadata, {:label=>'Publisher', :range=>::RDF::VCARD.VCard}, RDF::DC.publisher)
OpenMedia::Schema::RDF::Property.create_in_class!(metadata, {:label=>'Language', :range=>::RDF::XSD.string}, RDF::DC.language)
OpenMedia::Schema::RDF::Property.create_in_class!(metadata, {:label=>'Conforms To', :range=>::RDF::RDFS.Class}, RDF::DC.conformsTo)
OpenMedia::Schema::RDF::Property.create_in_class!(metadata, {:label=>'Description', :range=>::RDF::XSD.string}, RDF::DC.description)
OpenMedia::Schema::RDF::Property.create_in_class!(metadata, {:label=>'Title', :range=>::RDF::XSD.string}, RDF::DC.title)
OpenMedia::Schema::RDF::Property.create_in_class!(metadata, {:label=>'Type', :range=>::RDF::RDFS.Class}, RDF::DC.type)
OpenMedia::Schema::RDF::Property.create_in_class!(metadata, {:label=>'Created', :range=>::RDF::XSD.dateTime}, RDF::DC.created)
OpenMedia::Schema::RDF::Property.create_in_class!(metadata, {:label=>'Modified', :range=>::RDF::XSD.dateTime}, RDF::DC.modified)
