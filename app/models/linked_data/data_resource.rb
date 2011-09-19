class LinkedData::DataResource < CouchRest::Model::Base
  
  # use_database STAGING_DATABASE
  use_database VOCABULARIES_DATABASE
  
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
    vocab = LinkedData::Vocabulary.new(:term => self.term)
    vocab.namespace = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
  end
  
  def batch_serial_number
    ::Digest::MD5.hexdigest(Time.now.to_i.to_s + rand.to_s).to_s
  end
  
  def design_document(db)
    raise "You must specify a term" if self.term.nil?
    
    doc_id = "_design/#{self.term}"
    doc = db.get(doc_id) rescue nil
    
    if doc.nil?
    # Create a CouchDB design doc for DataResource instances
    doc = db.save_doc({"_id" => "#{doc_id}",
                        :language => "javascript",
                        :views => {
                          :all => {
                            :map =>
                              "function(doc) {if (doc['#{model_type_key}'] == '#{self.term}') {emit(doc['_id'],1);}}"
                          },
                          :vocabulary => {
                            :map =>
                              "function(doc) {if (doc['#{model_type_key}'] == 'LinkedData::Vocabulary' && doc['term'] == '#{self.term}') {emit(doc['_id'],1);}}"
                          }
                        }
                      })
    end
    doc
  end
  
  def spatial_view
    self.design_doc['spatial'] = {
      :by_geometry =>
        "function(doc) {if (doc['#{model_type_key}'] == '#{self.term}' && doc.geometry) {emit(doc.geometry, {id: doc._id, geometry: doc.geometry}); }}"
    }
  end
  
  def load!(records)

    bsn = batch_serial_number
    load_properties = {:batch_serial_number => bsn, :data_resource_id => self.term}
    
    recs_saved = 0
    records.each do |rec|
      OpenMedia::RawRecord.database.bulk_save_doc(rec.merge(load_properties))
      recs_saved += 1
      OpenMedia::RawRecord.database.bulk_save if recs_saved%500 == 0              
    end
    OpenMedia::RawRecord.database.bulk_save
    Hash[:id => self.term, :records_loaded => recs_saved, :batch_serial_number => bsn]
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