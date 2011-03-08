require 'etl'

class OpenMedia::Datasource < CouchRest::Model::Base

  TITLE_TAKEN_MSG = "already taken"
  
  use_database STAGING_DATABASE  

  TEXTFILE_TYPE = 'textfile'
  SHAPEFILE_TYPE = 'shapefile'  
  DATABASE_TYPE = 'database'

  TYPES = [TEXTFILE_TYPE, SHAPEFILE_TYPE]
  
  DELIMITED_PARSER = 'delimited'
  FIXED_WIDTH_PARSER = 'fixed_width'
  SAX_PARSER = 'sax'
  XML_PARSER = 'xml'

  PARSERS  = [DELIMITED_PARSER]

  before_create :update_metadata
  before_update :update_metadata
  
  property :source_type
  property :parser  
  property :column_separator    # separator for delimited parser
  property :skip_lines, Integer, :default=>0 # lines to skip (i.e. header rows) for delimited parser
  property :source_properties, [OpenMedia::DatasourceProperty]
  
  property :title
  property :unique_id_property
  property :rdfs_class_uri
  property :creator_uri
  property :publisher_uri
  property :metadata_uri    

  timestamps!
  
  validates :title, :presence=>true
  validates :rdfs_class_uri, :presence=>true
  validates :source_type, :presence=>true
  validates :parser, :presence=>true
  validates :creator_uri, :presence=>true
  validates :publisher_uri, :presence=>true  
  validate :dataset_validation

  view_by :rdfs_class_uri

  # Do prefix search on all datasets in memory (TODO: revisit this when it gets too slow)
  def self.search(title)
    self.all.select {|ds| ds.title =~ Regexp.new("^#{title}")}
  end

  def rdfs_class    
    OpenMedia::Schema::RDFS::Class.for(self.rdfs_class_uri)
  end

  def publisher
    OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(self.publisher_uri)
  end

  def creator
    OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(self.creator_uri)
  end

  def import!(opts={})
    if source_type==TEXTFILE_TYPE
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
    metadata.update!(:modified=>DateTime.now)
    ETL::Engine.rows_written
  end

  def metadata
    metadata_model.for(metadata_uri) if metadata_uri
  end

  def textfile?
    source_type == TEXTFILE_TYPE
  end

  def shapefile?
    source_type == SHAPEFILE_TYPE
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

  def metadata_model
    OpenMedia::Schema::RDFS::Class.for(RDF::METADATA.Metadata).spira_resource
  end

  def vcard_model
    OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource
  end  

  def update_metadata
    md_data = { :creator=>vcard_model.for(creator_uri),
      :publisher=>vcard_model.for(publisher_uri),
      :language=>'en-US',
      :conformsto=>rdfs_class,
      :title=>rdfs_class.label,
      :description=>rdfs_class.comment,
      :resourcetype=>RDF::DCTYPE.Dataset
    }
    if metadata
      metadata.update!(md_data)
      puts "updated"
    else
      md = metadata_model.for(RDF::METADATA.Metadata/"#{UUID.new.generate.gsub(/-/,'')}", md_data).save!
      self.metadata_uri = md.uri.to_s      
    end
  end
  
  
end
