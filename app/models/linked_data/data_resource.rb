class LinkedData::DataResource < CouchRest::Model::Base
  
  use_database STAGING_DATABASE
  
  belongs_to :vocabulary, :class_name => "LinkedData::Vocabulary"
  belongs_to :creator_contact, :class_name => "VCard::VCard"
  belongs_to :publisher_contact, :class_name => "VCard::VCard"

  property :uri
  property :term
  property :label

  timestamps!

  validates_presence_of :term

  def publisher
    VCard::Vcard.get(self.publisher_contact_id)
  end

  def creator
    VCard::Vcard.get(self.creator_contact_id)
  end
  
  def raw_records(view_opts={})
    OpenMedia::RawRecord.by_data_resource_id({:key=>self.id}.merge(view_opts))
  end  

  def unpublished_raw_records(view_opts={})
    OpenMedia::RawRecord.by_unpublished({:key=>self.id}.merge(view_opts))
  end  
  
  def raw_record_count
    OpenMedia::RawRecord.by_data_resource_id(:key=>self.id, :include_docs=>false)['rows'].size
  end

  def published_raw_record_count(view_opts={})
    OpenMedia::RawRecord.by_data_resource_id_and_published(:startkey=>[self.id], :endkey=>[self.id, {}], :include_docs=>false)['rows'].size
  end
  
  def create_vocabulary
    
  end
  
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
  
  def publish!
    # generate ETL ctl file from dataset and source definition
    ctl = "source :in, {:datasource=>'#{self.id}'}, ["+
      self.source_properties.collect{|p| p.identifier}.collect{|p| ":#{p}"}.join(',') + "]\n"
    ctl << "destination :out, {:rdfs_class=>'#{self.rdfs_class_uri}'}, {:order=>[" +
      self.rdfs_class.properties.collect{|p| p.identifier}.collect{|p| ":#{p}"}.join(',') + "]}\n"

    ETL::Engine.init(:datasource=>self)
    ETL::Engine.process_string(self, ctl)
    ETL::Engine.import = nil
    metadata.update!(:modified=>DateTime.now)
    ETL::Engine.rows_written
  end

  
end