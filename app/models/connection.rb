class Connection < CouchRest::Model::Base
  
  use_database VOCABULARIES_DATABASE
  
  END_POINT_TYPES = %w(Entry Log)
  
  
  property :name, String
  property :comment, String
  property :end_points, [EndPoint]  # [{"entry" => "source file access info"}, {"log" => "system logging endpoint access info"}]
  property :content_type
  
  
  def test_connection
  end
  
  def get_message
  end
  
end
