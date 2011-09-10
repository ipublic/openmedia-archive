# core_collection = LinkedData::Collection.get("http://openmedia.dev/om/collections#core")
xsd_string = LinkedData::Type.get("http://www.w3.org/2001/XMLSchema#string")
xsd_base64Binary = LinkedData::Type.get("http://www.w3.org/2001/XMLSchema#base64Binary")

comment = "A standard format for business cards"
vocab = LinkedData::Vocabulary.create!(:base_uri => "http://www.w3.org/2006/vcard/", 
                                        :label => "vCard",
                                        :term => "ns",
                                        :property_delimiter => "#",
                                        :curie_prefix => "vcard",
                                        :authority => @om_site.authority,
                                        :comment => comment
                                        )

ff_prop = LinkedData::Property.new(:label => "Formatted name", :term => "fn", :expected_type => xsd_string.uri)
nn_prop = LinkedData::Property.new(:label => "Nickname", :term => "nickname", :expected_type => xsd_string.uri)
tn_prop = LinkedData::Property.new(:label => "Job title", :term => "Title", :expected_type => xsd_string.uri)
ss_prop = LinkedData::Property.new(:label => "Sort string", :term => "sort-string", :expected_type => xsd_string.uri)
no_prop = LinkedData::Property.new(:label => "Note", :term => "note", :expected_type => xsd_string.uri)

fn_prop = LinkedData::Property.new(:label => "Last name", :term => "family-name", :expected_type => xsd_string.uri)
gn_prop = LinkedData::Property.new(:label => "First name", :term => "given-name", :expected_type => xsd_string.uri)
an_prop = LinkedData::Property.new(:label => "Middle name", :term => "additional-name", :expected_type => xsd_string.uri)
pn_prop = LinkedData::Property.new(:label => "Prefix", :term => "honorific-prefix", :expected_type => xsd_string.uri)
sn_prop = LinkedData::Property.new(:label => "Suffix", :term => "honorific-suffix", :expected_type => xsd_string.uri)

ou_prop = LinkedData::Property.new(:label => "Department", :term => "organization-unit", :expected_type => xsd_string.uri)
on_prop = LinkedData::Property.new(:label => "Organization name", :term => "organization-name", :expected_type => xsd_string.uri)

as_prop = LinkedData::Property.new(:label => "Address 1", :term => "street-address", :expected_type => xsd_string.uri)
ae_prop = LinkedData::Property.new(:label => "Address 2", :term => "extended-address", :expected_type => xsd_string.uri)
al_prop = LinkedData::Property.new(:label => "City", :term => "locality", :expected_type => xsd_string.uri)
ar_prop = LinkedData::Property.new(:label => "State", :term => "region", :expected_type => xsd_string.uri)
ap_prop = LinkedData::Property.new(:label => "Zipcode", :term => "postal-code", :expected_type => xsd_string.uri)
ac_prop = LinkedData::Property.new(:label => "Country", :term => "country-name", :expected_type => xsd_string.uri)

t_prop = LinkedData::Property.new(:label => "Type", :term => "type", :expected_type => xsd_string.uri)
v_prop = LinkedData::Property.new(:label => "Value", :term => "value", :expected_type => xsd_string.uri)

tt_prop = LinkedData::Property.new(:label => "Type", :term => "tel-type", 
                                      :enumerations => {:cell => "http://www.w3.org/2006/vcard/ns#Cell",
                                                        :work => "http://www.w3.org/2006/vcard/ns#Work",
                                                        :home => "http://www.w3.org/2006/vcard/ns#Home",
                                                        :fax => "http://www.w3.org/2006/vcard/ns#Fax"
                                                        },
                                      :expected_type => xsd_string.uri)

at_prop = LinkedData::Property.new(:label => "Type", :term => "adr-type", 
                                      :enumerations => {:work => "http://www.w3.org/2006/vcard/ns#Work",
                                                        :home => "http://www.w3.org/2006/vcard/ns#Home"
                                                        },
                                      :expected_type => xsd_string.uri)

ph_prop = LinkedData::Property.new(:label => "Photo", :term => "photo", :expected_type => xsd_base64Binary.uri)

## Define Types
name_type = LinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Name",
                                      :term => "n",
                                      :properties => [fn_prop, gn_prop, an_prop, pn_prop, sn_prop]
                                      ).save

org_type = LinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Organization",
                                      :term => "org",
                                      :properties => [on_prop, ou_prop]
                                      ).save

email_type = LinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Email",
                                      :term => "email",
                                      :properties => [v_prop, t_prop]
                                      ).save

tel_type = LinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Telephone",
                                      :term => "tel",
                                      :properties => [tt_prop, v_prop]
                                      ).save

addr_type = LinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Address",
                                      :term => "adr",
                                      :properties => [at_prop, as_prop, ae_prop, al_prop, ar_prop, ap_prop, ac_prop]
                                      ).save

vocab.types << name_type << org_type << email_type << tel_type << addr_type
vocab.properties << ff_prop << nn_prop << tn_prop << ss_prop << ph_prop
vocab.save!                         
