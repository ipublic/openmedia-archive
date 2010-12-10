require 'ruport'

class OpenMedia::Dataset < OpenMedia::DesignModel

  TITLE_TAKEN_MSG = "must be unique"
  
  use_database STAGING_DATABASE  

  before_create :generate_id, :generate_views
  after_create :update_model_views
  after_save :update_catalogs
  before_destroy {|ds| ds.model.all.each{|m| m.destroy}}

  property :title
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
      cls = Class.new(OpenMedia::DatasetModelTemplate)
      cls.dataset = self
      self.class.const_set(self.identifier, cls)
    end
    self.class.const_get(self.identifier)    
  end
  
  def set_properties(property_info)
    property_info.each do |pi|
      self.dataset_properties << OpenMedia::Property.new(:name=>pi[:name], :data_type=>pi[:data_type] || OpenMedia::Property::STRING_TYPE)
    end
  end

  def import_data_file!(source, opts={})
    opts = {:has_header_row=>true, :delimiter_character=>','}.merge(opts)
    attachment_name = "import-#{Time.now.to_i}-#{rand(10000)}"
    rtable = Ruport::Data::Table.parse(source, :has_names=>opts[:has_header_row],
                                       :csv_options => { :col_sep => opts[:delimiter_character] })
    rtable.each do |record|
      property_names = self.dataset_properties.collect{|p| p.name}
      d = self.model.create!(record.data.slice(*property_names).merge(:import_id=>attachment_name))
    end
    source.rewind
    attachment_attrs = {:file=>source, :name=>attachment_name}
    attachment_attrs[:content_type] = source.content_type if source.respond_to?(:content_type)
    self.create_attachment(attachment_attrs)                              
    self.save!    
  end

  # this is basically to make fields_for happy
  def dataset_properties_attributes=(attrs)
    self.dataset_properties = attrs
  end


private
  def dataset_validation
    if self.class.all.detect{|ds| (ds.id != self.id && ds.title==self.title) }
      self.errors.add(:title, TITLE_TAKEN_MSG)
    end

    if self.catalogs.size == 0
      errors.add(:base, 'Must belong to at least one catalog')
    end
  end

  def generate_id
    self.id = "_design/#{self.model_name}"
  end

  def generate_views
    self['views'] = { } # we have to put views here so that couchrest-model can add its views here later
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

  def update_model_views
    self.model.dataset=self
    self.model.save_design_doc
  end

  
end
