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
  property :skip_lines, Integer # lines to skip (i.e. header rows) for delimited parser
  property :source_properties, [OpenMedia::DatasourceProperty]
  
  property :title
  property :metadata, OpenMedia::Metadata
  property :unique_id_property
  property :data_type_uri

  timestamps!
  
  validates :title, :presence=>true
  validates :data_type_uri, :presence=>true
  validate :dataset_validation

  # Do prefix search on all datasets in memory (TODO: revisit this when it gets too slow)
  def self.search(title)
    self.all.select {|ds| ds.title =~ Regexp.new("^#{title}")}
  end
  
  def import!(opts={})
    if source_type==OpenMedia::Source::FILE_TYPE
      raise ETL::ControlError.new(':file required in options for a file source') unless opts[:file] 
    end

    # generate ctl from dataset and source definition
    ctl = "source :in, {:file=>'#{opts[:file]}', :parser=>'#{source.parser}', :skip_lines=>#{source.skip_lines}},["+
      self.source_properties.collect{|p| p.name}.collect{|p| ":#{p}"}.join(',') + "]\n"
    ctl << "destination :out, {:schema_type=>'#{self.data_type.id}'}, {:order=>[" +
      self.data_type.type_properties.collect{|p| p.name}.collect{|p| ":#{p}"}.join(',') + "]}\n"
    ETL::Engine.init(:dataset=>self)
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
