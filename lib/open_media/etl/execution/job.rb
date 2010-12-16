module OpenMedia::ETL #:nodoc:
  module Execution #:nodoc:
    # Persistent class representing an ETL job
    class Job < CouchRest::Model::Base
      use_database ETL_DATABASE

      property :control_file
      property :created_at, Time
      property :completed_at, Time
      property :status
      property :output
    end
  end
end
