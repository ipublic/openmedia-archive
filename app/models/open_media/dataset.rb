require 'etl'

class OpenMedia::Dataset < OpenMedia::DesignModel

  TITLE_TAKEN_MSG = "already taken"
  
  use_database STAGING_DATABASE  

  before_create :generate_id, :generate_views
  after_create :update_model_views
  after_save :update_catalog
  before_destroy {|ds| ds.model.all.each{|m| m.destroy}}

  property :title
  property :dataset_properties, [Property]
  property :metadata, OpenMedia::Metadata
  property :unique_id_property
  property :source, OpenMedia::Source

  timestamps!
  
  validates :title, :presence=>true
  validates :catalog, :presence=>true  
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

  def catalog
    @catalog ||= OpenMedia::Catalog.by_dataset_id(:key=>self.id).first
  end

  def catalog_id
    self.catalog ? self.catalog.id : nil
  end

  def catalog=(catalog)
    @catalog = catalog
  end

  def catalog_id=(cat_id)
    self.catalog = OpenMedia::Catalog.get(cat_id)
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

  def import!(opts={})
    if source && source.source_type==OpenMedia::Source::FILE_TYPE
      raise ETL::ControlError.new(':file required in options for a file source') unless opts[:file] 
    end

    # generate ctl from dataset and source definition
    ctl = "source :in, {:file=>'#{opts[:file]}', :parser=>'#{source.parser}', :skip_lines=>#{source.skip_lines}},["+
      self.source.source_properties.collect{|p| p.name}.collect{|p| ":#{p}"}.join(',') + "]\n"
    ctl << "destination :out, {:dataset=>'#{self.identifier}'}, {:order=>[" +
      self.dataset_properties.collect{|p| p.name}.collect{|p| ":#{p}"}.join(',') + "]}\n"
    ETL::Engine.init(:dataset=>self)
    ETL::Engine.process_string(self, ctl)
    ETL::Engine.import = nil
    ETL::Engine.rows_written
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
  end

  def generate_id
    self.id = "_design/#{self.model_name}"
  end

  def generate_views
    self['views'] = { } # we have to put views here so that couchrest-model can add its views here later
  end


  def update_catalog
    if @catalog
      unless @catalog.dataset_ids.include?(self.id)
        @catalog.datasets << self
        @catalog.save!
      end
    end
  end

  def update_model_views
    self.model.dataset=self
    self.model.save_design_doc
  end

  
end
