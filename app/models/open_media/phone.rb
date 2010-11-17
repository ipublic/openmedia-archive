class OpenMedia::Phone < Hash
  include CouchRest::Model::CastedModel  

  property :type
  property :number
 
  validates_presence_of :number
end

