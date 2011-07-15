class VCard::Telephone < Hash
  include CouchRest::Model::CastedModel    

  TELEPHONE_TYPES = %w(BBS Car Cell Fax Home ISDN Modem Msg PCS Pager Video Voice Work Pref)

  # based on vcard properties
  property :type   # BBS, Car, Cell, Fax, Home, ISDN, Modem, Msg, PCS, Pager, Video, Voice, Work, Pref
  property :value

end