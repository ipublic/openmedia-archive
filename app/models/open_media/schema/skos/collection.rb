class OpenMedia::Schema::SKOS::Collection
  include Spira::Resource
  
  default_source :types
  base_uri "http://data.openmedia.org/"
  type SKOS.Collection  

  property :label, :predicate=>SKOS.prefLabel, :type=>XSD.string
  has_many :members, :predicate=>SKOS.member

  validate :label_set

  def sub_collections
    members.collect{|m| OpenMedia::Schema::SKOS::Collection.for(m)}
  end

  def concepts
    members.collect{|c| OpenMedia::Schema::SKOS::Concept.for(c)}
  end

  def label_set
    assert_set(:label)
  end

  def self.create_in_collection!(collection, data)
    identifier = data[:label].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
    c = self.for(collection.uri/identifier, data)
    c.save!
    c
  end
  

  
end

