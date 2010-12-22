class OpenMedia::Import < CouchRest::Model::Base
  use_database STAGING_DATABASE

  belongs_to :dataset, :class_name=>'OpenMedia::Dataset'

  STATUS_EXECUTING = 'executing'
  STATUS_COMPLETED = 'completed'
  STATUS_COMPLETED_WITH_ERRORS = 'completed with errors'  

  property :control_file
  property :created_at, Time
  property :completed_at, Time
  property :status
  property :output

  timestamps!  
end

