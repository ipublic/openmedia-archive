class OpenMedia::Schema::Base
  include Spira::Resource

  base_uri "http://data.civicopenmedia.org/"  

  property :created, :predicate=>DC.created, :type=>XSD.dateTime
  property :modified, :predicate=>DC.modified, :type=>XSD.dateTime

  def before_create
    self.created=Time.now
  end

  def before_save
    self.modified=Time.now
  end

  def identifier
    if self.uri
      if self.uri.fragment
        self.uri.fragment.gsub(/[^a-z0-9]/,'_')
      else
        self.uri.path.split('/').last.downcase.gsub(/[^a-z0-9]/,'_')
      end
    end
  end

end
