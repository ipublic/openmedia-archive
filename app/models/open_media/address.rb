class OpenMedia::Address < Hash
  include CouchRest::Model::CastedModel    
  
  property :type
  property :address_1
  property :address_2
  property :city
  property :state_abbreviation
  property :zipcode
  property :note
  
  def to_html
    address_str = ""
    address_str << "#{address_1}" unless address_1.blank?
    address_str << "<br/>#{address_2}" unless address_2.blank?
    address_str << "<br/>#{city}" unless city.blank?
    address_str << ", #{state_abbreviation}" unless state_abbreviation.blank?
    address_str << " #{zipcode}" unless zipcode.blank?
    address_str
  end
  
end
