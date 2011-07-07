class OpenMedia::Telephone < Hash
  include CouchRest::Model::CastedModel    

  # based on vcard properties
  property :type   # BBS, Car, Cell, Fax, Home, ISDN, Modem, Msg, PCS, Pager, Video, Voice, Work, Pref
  property :value

end