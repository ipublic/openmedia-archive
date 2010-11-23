class OpenMedia::Dataset < OpenMedia::DesignModel
  
  use_database STAGING_DATABASE  

  before_create :generate_id
  after_save :update_catalogs

  property :title
  property :dataset_properties, [Property]
  property :metadata, OpenMedia::Metadata

  timestamps!
  
  validates :title, :presence=>true
  validate :dataset_validation

  def self.get(id, db = database)
    if id =~ /_design\/Dataset\/*/
      super(id, db)
    else
      super("_design/Dataset/#{id}", db)
    end
  end

  def self.all(opts = {})
    opts.merge!({:startkey => '_design/Dataset', :endkey => '_design/Dataset0', :include_docs=>true})
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

  def imports
    OpenMedia::Import.by_dataset_id
  end

  def class_name    
    self.title.gsub(/^(\d+)(.*)/,'\2').titleize.gsub(/[^\w\d]/,'')
  end


private
  def dataset_validation
    if self.class.all.detect{|ds| ds.title==self.title}
      self.errors.add(:title, 'must be unique')
    end

    if self.catalogs.size == 0
      errors.add(:base, 'Must belong to at least one catalog')
    end
  end

  def generate_id
    self.id = "_design/Dataset/" + self.class_name
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
