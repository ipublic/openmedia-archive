class OpenMedia::Schema::RDF::Property < OpenMedia::Schema::Base
  
  default_source 'types'
  base_uri "http://data.civicopenmedia.org/"
  type RDF.Property

  property :label, :predicate=>RDFS.label, :type=>XSD.string
  property :comment, :predicate=>RDFS.comment, :type=>XSD.string
  property :range, :predicate=>RDFS.range
  property :domain, :predicate=>RDFS.domain, :type=>:'OpenMedia::Schema::RDFS::Class'

  validate :check_required_fields
  
  def self.create_in_class!(rdfs_class, data, uri=nil)
    unless uri
      identifier = data[:label].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
      uri = rdfs_class.uri/"##{identifier}"
    end
    p = self.for(uri, data.merge(:domain=>rdfs_class))
    p.save!
    p
  end

  def identifier
    if self.uri
      if self.uri.fragment
        self.uri.fragment.gsub(/[^a-z0-9]/,'_')
      else
        self.uri.path.split('/').last.gsub(/[^a-z0-9]/,'_')
      end
    end
  end

  def check_required_fields
    assert(!self.label.blank?, :label, 'Label cannot be blank')
    assert(!self.range.blank?, :range, 'Range cannot be blank')
    assert(!self.domain.blank?, :domain, 'Domain cannot be blank')    
  end


end



