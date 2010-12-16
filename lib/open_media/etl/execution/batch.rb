module OpenMedia::ETL #:nodoc:
  module Execution #:nodoc:
    # Persistent class representing an ETL batch
    class Batch < CouchRest::Model::Base
      use_database ETL_DATABASE
      collection_of :jobs, :class_name=>'OpenMedia::ETL::Execution::Job'
    end
  end
end
