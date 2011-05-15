class OpenMedia::Map < CouchRest::Model::Base

  use_database SITE_DATABASE
  
  ## Property Definitions
  # General properties
  property :title
  property :description
  property :feature_class       # Schema class to show on map - must have geometries property
  property :feature_filter      # Constraint on features to include
  property :property_list, []   # Feature Class Properties to show in map pin balloon
  
  timestamps!
  
  validates :title, :presence => true
  view_by :title

end
