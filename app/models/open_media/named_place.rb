class OpenMedia::NamedPlace < Hash

  include CouchRest::Model::CastedModel    
  
  property :name
  property :state_abbreviation
  property :source
  property :source_id
  property :type
  property :description
  property :geometries, [GeoJson::Geometry]

  def find_by_name(municipality, state_abbrev)
    response = get(GEONAMES_PLACE_NAME, {:params => {:q => municipality,
                                                     :isNameRequired => true,
                                                     :country => 'us',
                                                     :adminCode1 => state_abbrev,
                                                     :featureClass => 'A',
                                                     :username => GEONAMES_USERNAME }})
  end

  

end
