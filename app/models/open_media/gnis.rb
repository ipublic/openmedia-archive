class OpenMedia::Gnis < Hash
  include CouchRest::Model::CastedModel    

  # Properties for USGS Geographic Names System (GNIS)
  # American National Standards Institute standards (ANSI INCITS 446-2008)
  # http://geonames.usgs.gov/domestic/
  
  property :feature_id
  property :feature_name
  property :feature_class
  property :citation
  property :entry_date
  
  # Coordinates are NAD83 decimal degrees
  property :latitude
  property :longitude
  property :elevation
  
  validates_numericality_of :latitude

end
