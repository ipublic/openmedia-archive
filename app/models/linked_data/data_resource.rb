class LinkedData::DataResource < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  
  property :database
  property :term
  property :label
  
  belongs_to :vocabulary, :class_name => "LinkedData::Vocabulary"

  validates_presence_of :term
  validates_presence_of :database
  validates_presence_of :vocabulary_id
  
    
  def create_design_doc
    raise "You must specify a database" if self.database.nil?
    raise "You must specify a term" if self.term.nil?
    
    # Create a CouchDB design doc for DataResource instances
    self.database.save_doc({
          "_id" => "_design/#{self.term}",
          :language => "javascript",
          :views => {
            :all => {
              :map =>
                "function(doc) {if (doc['model'] == '#{self.term}') {emit(doc['_id'],1);}}"
            },
            :vocabulary => {
              :map =>
                "function(doc) {if (doc['model'] == 'LinkedData::Vocabulary' && doc['term'] == '#{self.term}') {emit(doc['_id'],1);}}"
            }
          }
        })
  end
  
  def bulk_save
  end
  
end