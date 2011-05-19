class OpenMedia::DashboardMeasure < Hash
  include CouchRest::Model::CastedModel    
  
  property :measure
  property :source_class 
  property :source_property
  property :sort_property  
  property :measure_source_organization
  property :measure_source_url
  property :format
  property :visual
  property :rank
  property :values, :default=>[]

  def values
    if self['values'].empty? && !self.source_class.blank? && !self.source_property.blank?
      if !self.sort_property.blank?
        self['values'] = OpenMedia::Schema.get_records(self.source_class).sort{|r1,r2| r1[self.sort_property] <=> r2[self.sort_property]}.collect{|r| r[self.source_property]}
      else
        self['values'] = OpenMedia::Schema.get_records(self.source_class).collect{|r| r[self.source_property]}
      end

    end
    self['values']
  end

end
