class OpenMedia::Dashboard < CouchRest::Model::Base
  
  use_database SITE_DATABASE
  
  ## Property Definitions
  # General properties
  property :title
  property :description
  property :groups, [OpenMedia::DashboardGroup], :default => []
  
  timestamps!
  
  validates :title, :presence => true
  view_by :title

end