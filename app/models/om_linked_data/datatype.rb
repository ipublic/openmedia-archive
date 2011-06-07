class LinkedData::DataType < CouchRest::Model::Base
  
  use_database TYPES_DATABASE
  unique_id :identifier

  belongs_to :namespace, :class_name => "LinkedData::Namespace"
  
  property :identifier
  property :label
  
  view_by :label
  view_by :namespace_id

private
  def generate_identifier
    self['identifier'] ||= self.class.to_s.split("::").last.downcase + '_' +
                           self.namespace.authority_uri + '_' +
                           label.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end


end