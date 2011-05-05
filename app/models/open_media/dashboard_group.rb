class OpenMedia::DashboardGroup < Hash
  include CouchRest::Model::CastedModel    
  
  property :title
  property :description
  property :measures, :default => []

end