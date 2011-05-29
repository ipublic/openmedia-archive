class Schema::Namespace < Hash
  include CouchRest::Model::CastedModel
  
  property :alias, String            # alias => "foaf"
  property :iri_base, String         # iri_base => "http://xmlns.com/foaf/0.1/"

  validates_presence_of :alias, :iri_base

  def alias=(value)
    self["alias"] = value.to_s.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'')
  end
end