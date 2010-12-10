class OpenMedia::Metadata < Hash

  include CouchRest::Model::CastedModel  

  # See http://dublincore.org/documents/usageguide/elements.shtml

  ## These propoerties are DCMI
  property :title
  property :description
  property :uri

  # Reference DCMI Type vocubulary: http://dublincore.org/documents/dcmi-type-vocabulary/
  property :type, :alias => :dcmi_type, :default => 'Dataset'

  property :keywords, [String]

  belongs_to :creator, :class_name => 'OpenMedia::Organization'
  belongs_to :publisher, :class_name => 'OpenMedia::Organization'
  belongs_to :maintainer, :class_name => 'OpenMedia::Organization'  

  property :language, :default => 'en-US'

  # reference to Open311, NIEM UCR other standards
  property :conforms_to

  # See http://geonames.usgs.gov/domestic/metadata.htm
  property :geographic_coverage  # Geographic bounds, jurisdiction name from controlled vocab, 
                              # e.g.; GNIS or Thesaurus of Geographic Names [TGN]
  property :update_frequency, :alias => :accrual_periodity # , :alias => :update_interval_in_minutes

  # earliest and oldest record in set
  property :beginning_date, Date
  property :ending_date, Date

  # property :beginning_date, :type => Date
  # property :ending_date, :type => Date

  # creation or availability date of the resource
  property :created_date, Date
  property :last_updated, Date
  property :released, Date 

  # string or URL describing usage, disclaimers 
  property :license, :alias => :rights

  def keywords=(keywords)
    write_attribute('keywords', (keywords.is_a?(Array) ? keywords : keywords.split(',').collect{|w| w.strip}))
  end


  ## Validations
#  validates_presence_of :creator_organization_id

  # def created_date_string
  #   return if created_date.nil?
  #   created_date.strftime("%m/%d/%Y")
  # end
  # 
  # def created_date_string=(created_date_str)
  #   self['created_date'] = created_date_str #Date.parse(created_date_str)
  # rescue ArgumentError
  #   @created_date_invalid = true
  # end
  # 
  # def validate
  #   errors.add(:created_date, "is invalid") if @created_date_invalid
  # end

end
