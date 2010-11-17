require 'open_media/design_model'

class OpenMedia::Dataset < OpenMedia::DesignModel
  
  use_database STAGING_DATABASE  

  before_create :generate_id

  property :title
  property :dataset_properties, [Property]
  property :metadata, Metadata

  timestamps!
  
  validates :title, :presence=>true

  validates_each :title do |dataset, attribute, value|
    # check title uniqueness manually for now
    if attribute == :title
      if self.all.detect{|ds| ds.title==value}
        dataset.errors.add(:title, 'must be unique')
      end
    end
  end
  
  def self.all(opts = {})
    opts.merge!({:startkey => '_design/Dataset', :endkey => '_design/Dataset0', :include_docs=>true})
    database.documents(opts)['rows'].collect{|d| create_from_database(d['doc'])}
  end

  def self.count
    self.all.size
  end
 

  # dataset property convenience methods
  def get_dataset_property(name)
    self.dataset_properties.detect{|ds| ds.name==name}
  end

  def delete_dataset_property(name)
    self.dataset_properties.delete(self.dataset_properties.detect{|ds| ds.name==name})
  end  


private
  def generate_id
    self.id = "_design/Dataset/" + self.title.gsub(/^(\d+)(.*)/,'\2').titleize.gsub(/[^\w\d]/,'')
  end
  
end
