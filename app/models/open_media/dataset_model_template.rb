class OpenMedia::DatasetModelTemplate < CouchRest::Model::Base

  class_inheritable_accessor :dataset
  
  use_database STAGING_DATABASE
  
  belongs_to :job, :class_name=>'OpenMedia::ETL::Execution::Job'
  
  timestamps!

  validates_presence_of :job_id

  view_by :import_id

  # make sure we update the Dataset when updating our design document because they're the same thing.
  # But we still want to get the latest views from couchdb in case another process updated them on us
  def self.stored_design_doc(db = database)
    self.dataset.merge!(super['views'])
  end
  
  
end
