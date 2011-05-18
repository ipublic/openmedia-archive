class OpenMedia::DashboardMeasure < Hash
  include CouchRest::Model::CastedModel    
  
  property :measure
  property :om_source_class 
  property :om_source_property
  property :measure_source_organization
  property :measure_source_url
  property :format
  property :visual
  property :rank
  property :values
end
