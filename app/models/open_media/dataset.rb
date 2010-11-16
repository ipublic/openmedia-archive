require 'open_media/design_model'

class OpenMedia::Dataset < OpenMedia::DesignModel
  
  use_database STAGING_DATABASE  

  before_create :generate_id
  
  validates_presence_of :name

private
  def generate_id
    self.id = "_design/" + self.name.gsub(/^(\d+)(.*)/,'\2').titleize.gsub(/[^\w\d]/,'')
  end
  
end
