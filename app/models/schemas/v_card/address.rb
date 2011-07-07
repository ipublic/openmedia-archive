class Schemas::VCard::Address < Hash
  include CouchRest::Model::CastedModel    

  # based on vcard properties
  property :type, String
  property :address_1, String   # :alias => "street-address"
  property :address_2, String   # :alias => "extended-address"
  property :city, String   # :alias => "locality"
  property :state, String   # :alias => "region"
  property :zipcode, String   # :alias => "postal-code"
  property :country, String   # :alias => "country-name"
  
  def to_html
    address_str = ""
    address_str << "#{address_1}" unless address_1.blank?
    address_str << "<br/>#{address_2}" unless address_2.blank?
    address_str << "<br/>#{city}" unless city.blank?
    address_str << ", #{state}" unless state.blank?
    address_str << " #{zipcode}" unless zipcode.blank?
    address_str << "<br/>#{country}" unless country.blank?
    address_str
  end
  
end
