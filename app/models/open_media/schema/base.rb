require 'open_media/schema/types'

class OpenMedia::Schema::Base
  include Spira::Resource

  property :created, :predicate=>DC.created, :type=>XSD.dateTime
  property :modified, :predicate=>DC.modified, :type=>XSD.dateTime

  def before_create
    self.created=Time.now
  end

  def before_save
    self.modified=Time.now
  end


end
