require 'etl'

class OpenMedia::Datasource < CouchRest::Model::Base

  TITLE_TAKEN_MSG = "already taken"
  
  use_database STAGING_DATABASE  

  FILE_TYPE = 'file'
  DATABASE_TYPE = 'database'

  TYPES = [FILE_TYPE]
  
  DELIMITED_PARSER = 'delimited'
  FIXED_WIDTH_PARSER = 'fixed_width'
  SAX_PARSER = 'sax'
  XML_PARSER = 'xml'

  PARSERS  = [DELIMITED_PARSER] 
  
  property :source_type
  property :parser  
  property :column_separator    # separator for delimited parser
  property :skip_lines, Integer, :default=>0 # lines to skip (i.e. header rows) for delimited parser
  property :source_properties, [OpenMedia::DatasourceProperty]
  
  property :title
  property :metadata, OpenMedia::Metadata
  property :unique_id_property
  property :rdfs_class_uri

  timestamps!
  
  validates :title, :presence=>true
  validates :rdfs_class_uri, :presence=>true
  validates :source_type, :presence=>true
  validates :parser, :presence=>true    
  validate :dataset_validation

  # Do prefix search on all datasets in memory (TODO: revisit this when it gets too slow)
  def self.search(title)
    self.all.select {|ds| ds.title =~ Regexp.new("^#{title}")}
  end

  def rdfs_class    
    OpenMedia::Schema::RDFS::Class.for(self.rdfs_class_uri)
  end

  
  def import!(opts={})
    if source_type==FILE_TYPE
      raise ETL::ControlError.new(':file required in options for a file source') unless opts[:file] 
    end

    # generate ctl from dataset and source definition
    ctl = "source :in, {:file=>'#{opts[:file]}', :parser=>'#{self.parser}', :skip_lines=>#{self.skip_lines}},["+
      self.source_properties.collect{|p| p.identifier}.collect{|p| ":#{p}"}.join(',') + "]\n"
    ctl << "destination :out, {:rdfs_class=>'#{self.rdfs_class_uri}'}, {:order=>[" +
      self.rdfs_class.properties.collect{|p| p.identifier}.collect{|p| ":#{p}"}.join(',') + "]}\n"
    ETL::Engine.init(:datasource=>self)
    ETL::Engine.process_string(self, ctl)
    ETL::Engine.import = nil
    ETL::Engine.rows_written
  end

private
  def dataset_validation
    if self.class.all.detect{|ds| (ds.id != self.id && ds.title==self.title) }
      self.errors.add(:title, TITLE_TAKEN_MSG)
    end
  end

  def generate_id
    self.id = "_design/#{self.model_name}"
  end
  
end
