core_collection = ::OmLinkedData::Collection.find_by_label("Core")

xsd_string = ::OmLinkedData::Type.find_by_term(:key => "string")
xsd_base64Binary = ::OmLinkedData::Type.find_by_term(:key => "base64Binary")

comment = "A standard format for business cards"
vocab = ::OmLinkedData::Vocabulary.new(:base_uri => "http://www.w3.org/2006/vcard/", 
                                        :label => "vCard",
                                        :term => "ns",
                                        :property_delimiter => "#",
                                        :curie_prefix => "v",
                                        :collection => core_collection,
                                        :comment => comment
                                        ).save

ff_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Formatted name", :term => "fn", :expected_type => xsd_string).save
nn_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Nickname", :term => "nickname", :expected_type => xsd_string).save
tn_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Job title", :term => "Title", :expected_type => xsd_string).save
ss_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Sort string", :term => "sort-string", :expected_type => xsd_string).save
no_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Note", :term => "note", :expected_type => xsd_string).save

fn_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Last name", :term => "family-name", :expected_type => xsd_string).save
gn_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "First name", :term => "given-name", :expected_type => xsd_string).save
an_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Middle name", :term => "additional-name", :expected_type => xsd_string).save
pn_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Prefix", :term => "honorific-prefix", :expected_type => xsd_string).save
sn_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Suffix", :term => "honorific-suffix", :expected_type => xsd_string).save

ou_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Department", :term => "organization-unit", :expected_type => xsd_string).save
on_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Organization name", :term => "organization-name", :expected_type => xsd_string).save

as_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Address 1", :term => "street-address", :expected_type => xsd_string).save
ae_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Address 2", :term => "extended-address", :expected_type => xsd_string).save
al_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "City", :term => "locality", :expected_type => xsd_string).save
ar_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "State", :term => "region", :expected_type => xsd_string).save
ap_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Zipcode", :term => "postal-code", :expected_type => xsd_string).save
ac_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Country", :term => "country-name", :expected_type => xsd_string).save

t_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Type", :term => "type", :expected_type => xsd_string).save
v_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Value", :term => "value", :expected_type => xsd_string).save

tt_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Type", :term => "tel-type", 
                                      :enumerations => {:cell => "http://www.w3.org/2006/vcard/ns#Cell",
                                                        :work => "http://www.w3.org/2006/vcard/ns#Work",
                                                        :home => "http://www.w3.org/2006/vcard/ns#Home",
                                                        :fax => "http://www.w3.org/2006/vcard/ns#Fax"
                                                        },
                                      :expected_type => xsd_string).save

at_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Type", :term => "adr-type", 
                                      :enumerations => {:work => "http://www.w3.org/2006/vcard/ns#Work",
                                                        :home => "http://www.w3.org/2006/vcard/ns#Home"
                                                        },
                                      :expected_type => xsd_string).save

ph_prop = ::OmLinkedData::Property.new(:vocabulary => vocab, :label => "Photo", :expected_type => xsd_base64Binary).save

## Define Types
name_type = ::OmLinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Name",
                                      :term => "n",
                                      :properties => [fn_prop, gn_prop, an_prop, pn_prop, sn_prop]
                                      ).save

org_type = ::OmLinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Organization",
                                      :term => "org",
                                      :properties => [on_prop, ou_prop]
                                      ).save

email_type = ::OmLinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Email",
                                      :term => "email",
                                      :properties => [v_prop, t_prop]
                                      ).save

tel_type = ::OmLinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Telephone",
                                      :term => "tel",
                                      :properties => [tt_prop, v_prop]
                                      ).save

addr_type = ::OmLinkedData::Type.new(:vocabulary => vocab, 
                                      :label => "Address",
                                      :term => "adr",
                                      :properties => [at_prop, as_prop, ae_prop, al_prop, ar_prop, ap_prop, ac_prop]
                                      ).save

vocab.types = [name_type, org_type, email_type, tel_type, addr_type]
vocab.properties = [ff_prop, nn_prop, tn_prop, ss_prop, ph_prop]
vocab.save!                         
