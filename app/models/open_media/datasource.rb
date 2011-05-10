require 'etl'
require 'md5'

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

  # before_create :update_metadata
  # before_update :update_metadata
  
  property :source_type
  property :parser  
  property :column_separator    # separator for delimited parser
  property :has_header_row
  property :source_properties, [OpenMedia::DatasourceProperty]
  
  property :title
  property :unique_id_property
  property :rdfs_class_uri
  property :creator_uri
  property :publisher_uri
  property :metadata_uri    

  timestamps!
  
  validates :title, :presence=>true
  validates :source_type, :presence=>true
  validates :parser, :presence=>true

  view_by :rdfs_class_uri

  # Do prefix search on all datasets in memory (TODO: revisit this when it gets too slow)
  def self.search(title)
    self.all.select {|ds| ds.title =~ Regexp.new("^#{title}")}
  end

  def rdfs_class    
    OpenMedia::Schema::RDFS::Class.for(self.rdfs_class_uri) if self.rdfs_class_uri
  end

  def publisher
    OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(self.publisher_uri)
  end

  def creator
    OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(self.creator_uri)
  end

  def initial_import!(file=nil)
    if self.parser==DELIMITED_PARSER
      rows_parsed = 0
      batch_serial_number = MD5.md5(Time.now.to_i.to_s + rand.to_s).to_s
      FasterCSV.foreach(file.path, :col_sep=>self.column_separator) do |row|
        rows_parsed += 1
        # create properties when processing first row
        if rows_parsed==1
          properties = []
          if self.has_header_row
            row.each{|pn| self.source_properties << OpenMedia::DatasourceProperty.new(:label=>pn, :range_uri=>RDF::XSD.string.to_s)}            
          else
            1.upto(row.size) {|i| self.source_properties << OpenMedia::DatasourceProperty(:label=>"Column#{i}", :range=>RDF::XSD.string.to_s)}
          end
          self.save!
          next if self.has_header_row
        end
        
        raw_record = OpenMedia::RawRecord.new(:datasource=>self, :batch_serial_number=>batch_serial_number)
        row.each_with_index {|val, idx| raw_record[self.source_properties[idx].identifier]=val}
        raw_record.save!
      end
    end

  end


  def import!(opts={})
    if source_type==TEXTFILE_TYPE
      raise ETL::ControlError.new(':file required in options for a file source') unless opts[:file] 
    end

    # generate ctl from dataset and source definition
    ctl = "source :in, {:file=>'#{opts[:file]}', :parser=>{:name=>'#{self.parser}', :options=>{:col_sep=>'#{self.column_separator}'}}, :skip_lines=>#{self.skip_lines}},["+
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
    OpenMedia::Schema::RDFS::Class::HttpDataCivicopenmediaOrgCoreMetadataMetadata.for(metadata_uri) if metadata_uri
  end

  def textfile_source?
    source_type == TEXTFILE_TYPE
  end

  def shapefile_source?
    source_type == SHAPEFILE_TYPE
  end

  def raw_records
    OpenMedia::RawRecord.by_datasource_id(:key=>self.id)
  end

  def raw_record_count
    OpenMedia::RawRecord.by_datasource_id(:key=>self.id, :include_docs=>false)['total_rows']
  end



end
