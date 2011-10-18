class LinkedData::DataSource < CouchRest::Model::Base

  attr_accessor :docs_read, :docs_written
  
  use_database STAGING_DATABASE
  unique_id :identifier
  
  CSV_SOURCE_TYPE = "csv"
  SHAPEFILE_SOURCE_TYPE = "shapefile"
  URL_SOURCE_TYPE = "url"
  
  property :term, String
  property :identifier, String
  property :label, String
  property :properties, [LinkedData::Property]

  # property :transform_model do
  #   property :exe_order, Float
  #   property :source_property_term, String
  #   property :destination_topic_id, String
  #   property :destination_topic_property_term, String
  #   property :method, String
  #   property :parameters, String
  # end
  
  property :extract_sets do
    property :serial_number, String
    property :docs_written, Integer
    property :extracted_at, Time
  end

  timestamps!

  validates_presence_of :term
  
  ## Callbacks
  before_create :generate_identifier

  design do
    view :by_term
    view :by_label
  end
  
  def last_extract(view_opts={})
    unless self.extract_sets.nil?
      LinkedData::RawRecord.by_serial_number({:key=>self.extract_sets.last.serial_number}.merge(view_opts))
    end
  end

  def raw_records(view_opts={})
    LinkedData::RawRecord.by_data_source_id({:key=>self.id}.merge(view_opts))
  end  

  def unpublished_raw_records(view_opts={})
    LinkedData::RawRecord.by_unpublished({:key=>self.id}.merge(view_opts))
  end  
  
  def raw_doc_count
    LinkedData::RawRecord.by_data_source_id(:key=>self.id, :include_docs=>false)['rows'].size
  end

  def raw_doc_published_count(view_opts={})
    LinkedData::RawRecord.by_data_source_id_and_published(:startkey=>[self.id], :endkey=>[self.id, {}], :include_docs=>false)['rows'].size
  end
  
  def self.serial_number
    ::Digest::MD5.hexdigest(Time.now.to_i.to_s + rand.to_s).to_s
  end
  
  def extract!(records)
    raise "DataSource must be saved to database first" if self.identifier.nil?
    esn = LinkedData::DataSource.serial_number
    ts = Time.now.utc
    extract_prop_set = {:serial_number => esn, :data_source_id => self.identifier, 
                        :created_at => ts, :updated_at => ts}
    
    records.each do |rec|
      LinkedData::RawRecord.database.bulk_save_doc(rec.merge(extract_prop_set))
      self.docs_written += 1
      LinkedData::RawRecord.database.bulk_save if docs_written%500 == 0              
    end
    LinkedData::RawRecord.database.bulk_save
    extract_sets << Hash[:serial_number => esn, :docs_written => docs_written, :extracted_at => ts]
    self.save # Persist the updated extract_sets array 
    extract_sets.last
  end
  
  
  def transform!
    # generate ctl from dataset and source definition
    ctl = "source :in, {:datasource=>'#{self.id}'}, #{instance_properties}\n"
    ctl << "destination :out,{:order=> #{instance_properties}}\n"

    
    # ctl = "source :in, {:datasource=>'#{self.id}'}, ["+
    #   self.source_properties.collect{|p| p.identifier}.collect{|p| ":#{p}"}.join(',') + "]\n"
    # ctl << "destination :out, {:rdfs_class=>'#{self.rdfs_class_uri}'}, {:order=>[" +
    #   self.rdfs_class.properties.collect{|p| p.identifier}.collect{|p| ":#{p}"}.join(',') + "]}\n"

    ETL::Engine.init(:datasource=>self)
    ETL::Engine.process_string(self, ctl)
    ETL::Engine.import = nil
    metadata.update!(:modified=>DateTime.now)
    ETL::Engine.rows_written
  end
  
  def docs_read
    @docs_read ||= 0
  end
  
  def docs_written
    @docs_written ||= 0
  end
  

private
  def generate_identifier
    self.label ||= self.term
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         escape_string(self.term.downcase) if new?
  end

  def escape_string(str)
    str.gsub(/[^A-Za-z0-9]/,'_').squeeze('_')
  end
  
end