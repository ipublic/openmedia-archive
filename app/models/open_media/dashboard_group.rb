class OpenMedia::DashboardGroup < Hash
  include CouchRest::Model::Embeddable
  
  property :title
  property :description
  property :measures, [OpenMedia::DashboardMeasure], :default => []

end
