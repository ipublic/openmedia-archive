class LinkedData::DataSource < CouchRest::Model::Base
  
  use_database STAGING_DATABASE
  unique_id :identifier
  
  CSV_SOURCE_TYPE = "csv"
  SHAPEFILE_SOURCE_TYPE = "shapefile"
  URL_SOURCE_TYPE = "url"
  
  property :term, String
  property :identifier, String
  property :label, String
  property :authority, String
  
  property :extract_sets do
    property :serial_number, String
    property :record_count, Integer
    property :extracted_at, Time
  end

  timestamps!

  validates_presence_of :term
  validates_presence_of :authority
  
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
  
  def raw_record_count
    LinkedData::RawRecord.by_data_source_id(:key=>self.id, :include_docs=>false)['rows'].size
  end

  def published_raw_record_count(view_opts={})
    LinkedData::RawRecord.by_data_source_id_and_published(:startkey=>[self.id], :endkey=>[self.id, {}], :include_docs=>false)['rows'].size
  end
  
  def self.serial_number
    ::Digest::MD5.hexdigest(Time.now.to_i.to_s + rand.to_s).to_s
  end
  
  def extract!(records)
    raise "DataSource must be saved to database first" if self.identifier.nil?
    esn = LinkedData::DataSource.serial_number
    ts = Time.now
    extract_prop_set = {:serial_number => esn, :data_source_id => self.identifier, 
                        :created_at => ts, :updated_at => ts}
    
    recs_saved = 0
    records.each do |rec|
      LinkedData::RawRecord.database.bulk_save_doc(rec.merge(extract_prop_set))
      recs_saved += 1
      LinkedData::RawRecord.database.bulk_save if recs_saved%500 == 0              
    end
    LinkedData::RawRecord.database.bulk_save
    extract_sets << Hash[:serial_number => esn, :record_count => recs_saved, :extracted_at => ts]
    self.save
    extract_sets.last
  end

private
  def generate_identifier
    self.label ||= self.term
    self['identifier'] = self.class.to_s.split("::").last.downcase + '_' +
                         self.authority + '_' + 
                         escape_string(self.term.downcase) if new?
  end

  def escape_string(str)
    str.gsub(/[^A-Za-z0-9]/,'_').squeeze('_')
  end
  
end