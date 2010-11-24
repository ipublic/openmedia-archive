require 'ruport'

class OpenMedia::Dataset < OpenMedia::DesignModel

  SAMPLE_DATA_ATTACHMENT_NAME = 'sample-data'
  
  use_database STAGING_DATABASE  

  before_create :generate_id, :generate_views
  after_save :update_catalogs

  property :title
  property :delimiter_character, :default=>','
  property :has_header_row, TrueClass, :default => true
  property :dataset_properties, [Property]
  property :metadata, OpenMedia::Metadata
  property :unique_id_property

  timestamps!
  
  validates :title, :presence=>true
  validate :dataset_validation

  def self.get(id, db = database)
    if id =~ /_design\/OpenMedia::Dataset\/*/
      super(id, db)
    else
      super("_design/OpenMedia::Dataset::#{id}", db)
    end
  end

  def self.all(opts = {})
    opts.merge!({:startkey => '_design/OpenMedia::Dataset::', :endkey => '_design/OpenMedia::Dataset::\u9999', :include_docs=>true})
    database.documents(opts)['rows'].collect{|d| create_from_database(d['doc'])}
  end

  # Do prefix search on all datasets in memory (TODO: revisit this when it gets too slow)
  def self.search(title)
    self.all.select {|ds| ds.title =~ Regexp.new("^#{title}")}
  end

  def self.count
    self.all.size
  end

  def catalogs
    @catalogs ||= OpenMedia::Catalog.by_dataset_id(:key=>self.id)
  end

  def catalog_ids
    self.catalogs.collect{|c| c.id}
  end

  def catalogs=(catalogs)
    @catalogs = catalogs
  end

  def catalog_ids=(cat_ids)
    self.catalogs = cat_ids.collect{|cid| OpenMedia::Catalog.get(cid)}
  end

  # dataset property convenience methods
  def get_dataset_property(name)
    self.dataset_properties.detect{|ds| ds.name==name}
  end

  def delete_dataset_property(name)
    self.dataset_properties.delete(self.dataset_properties.detect{|ds| ds.name==name})
  end

  def identifier    
    self.title.gsub(/^(\d+)(.*)/,'\2').titleize.gsub(/[^\w\d]/,'')
  end

  def model_name
    "#{self.class.name}::#{identifier}"
  end

  def model
    if !self.class.const_defined?(self.identifier)
      self.class.const_set(self.identifier, Class.new(OpenMedia::DatasetModelTemplate))
    end
    self.class.const_get(self.identifier)    
  end
  


  def initialize_properties!(source)
    rtable = Ruport::Data::Table.parse(source, :has_names=>self.has_header_row,
                                        :csv_options => { :col_sep => self.delimiter_character })
    rtable[0].attributes.each do |a|
      self.dataset_properties << OpenMedia::Property.new(:name=>a, :data_type=>OpenMedia::Property::STRING_TYPE)
    end
    source.rewind
    attachment_attrs = {:file=>source, :name=>SAMPLE_DATA_ATTACHMENT_NAME}
    attachment_attrs[:content_type] = source.content_type if source.respond_to?(:content_type)
    self.create_attachment(attachment_attrs)                              
    self.save!
  end

  def get_sample_record(record_number)
    rtable = Ruport::Data::Table.parse(self.sample_data, :has_names=>self.has_header_row,
                                        :csv_options => { :col_sep => self.delimiter_character })
    rtable[record_number]
  end

  def sample_data
    self.read_attachment(SAMPLE_DATA_ATTACHMENT_NAME)
  end  

  def import_attachment!(attachment_name)
    rtable = Ruport::Data::Table.parse(self.read_attachment(attachment_name), :has_names=>self.has_header_row,
                                       :csv_options => { :col_sep => self.delimiter_character })
    rtable.each do |record|
      d = self.model.create!(record.data.merge(:import_id=>attachment_name))
    end
  end

private
  def dataset_validation
    if self.class.all.detect{|ds| (ds.id != self.id && ds.title==self.title) }
      self.errors.add(:title, 'must be unique')
    end

    if self.catalogs.size == 0
      errors.add(:base, 'Must belong to at least one catalog')
    end
  end

  def generate_id
    self.id = "_design/#{self.model_name}"
  end

  def generate_views
    self['views'] = { }  # we have to put views here so that couchrest-model can add its views here later
  end


  def update_catalogs
    if @catalogs
      @catalogs.each do |c|
        unless c.dataset_ids.include?(self.id)
          c.datasets << self
          c.save!
        end
      end
    end
  end


  
end
