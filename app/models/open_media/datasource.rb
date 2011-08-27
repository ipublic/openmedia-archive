require 'etl'
require 'md5'

class OpenMedia::Datasource < CouchRest::Model::Base

  TITLE_TAKEN_MSG = "already taken"
  
  use_database STAGING_DATABASE  

  TEXTFILE_TYPE = 'textfile'
  SHAPEFILE_TYPE = 'shapefile'  
  DATABASE_TYPE = 'database'
  WEBSERVICE_TYPE = 'webservice'  

  TYPES = [TEXTFILE_TYPE, SHAPEFILE_TYPE]
  
  DELIMITED_PARSER = 'delimited'
  FIXED_WIDTH_PARSER = 'fixed_width'
  SAX_PARSER = 'sax'
  XML_PARSER = 'xml'

  PARSERS  = [DELIMITED_PARSER]  
  
  #before_create :update_metadata
  #before_update :update_metadata
  
  property :source_type
  property :parser  
  property :column_separator    # separator for delimited parser
  property :has_header_row
  property :webservice_url
  property :source_properties, [OpenMedia::DatasourceProperty]
  
  property :title
  property :unique_id_property
  property :rdfs_class_uri
  property :creator_uri
  property :publisher_uri
  property :metadata_uri    

  belongs_to :creator_contact, :class_name => "VCard::VCard"
  belongs_to :publisher_contact, :class_name => "VCard::VCard"

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
    VCard::Vcard.get(self.publisher_contact_id)
  end

  def creator
    VCard::Vcard.get(self.creator_contact_id)
  end

  def has_header_row=(hhr)
    if hhr && hhr.class != TrueClass && hhr.class != FalseClass
      self['has_header_row'] = (hhr.match(/(true|t|yes|y|1)$/i) != nil)
    end
  end


  def initial_import!(file=nil)
    batch_serial_number = MD5.md5(Time.now.to_i.to_s + rand.to_s).to_s
    rows_parsed = 0    
    if self.textfile_source?
      if self.parser==DELIMITED_PARSER
        CSV.foreach(file.path, :col_sep=>self.column_separator) do |row|
          rows_parsed += 1
          # create properties when processing first row
          if rows_parsed==1
            if self.has_header_row
              row.each{|pn| self.source_properties << OpenMedia::DatasourceProperty.new(:label=>pn, :range_uri=>RDF::XSD.string.to_s)}            
            else
              1.upto(row.size) {|i| self.source_properties << OpenMedia::DatasourceProperty.new(:label=>"Column%03i"%i, :range_uri=>RDF::XSD.string.to_s)}
            end
            self.save!
            next if self.has_header_row
          end

          # detect source property types based on first row of data
          if rows_parsed==1 || (rows_parsed==2 && self.has_header_row)
            self.source_properties.each_with_index {|dsp,idx| dsp.set_range_from_csv_value(row[idx])}
            self.save!
          end

          
          raw_record = OpenMedia::RawRecord.new(:datasource=>self, :batch_serial_number=>batch_serial_number)
          row.each_with_index do |val, idx|
            source_property = self.source_properties[idx]
            if val && source_property.range_uri == RDF::XSD.integer.to_s
              val = val.to_i
            elsif val && source_property.range_uri == RDF::XSD.float.to_s
              val = val.to_f
            end
            raw_record[source_property.identifier]=val
          end
          #raw_record.save!
          raw_record['created_at'] = Time.now
          raw_record['updated_at'] = Time.now          
          OpenMedia::RawRecord.database.bulk_save_doc(raw_record)
          OpenMedia::RawRecord.database.bulk_save if rows_parsed%500 == 0
        end
        OpenMedia::RawRecord.database.bulk_save
      end
    elsif self.shapefile_source?
      Dir.mktmpdir do |temp_dir|
        `#{UNZIP} #{file.path} -d #{temp_dir}`
        shpfn = Dir.glob(File.join(temp_dir,'*.shp')).first
        if shpfn
          jsfn = shpfn.gsub(/\.shp/,'.js')
          %x!#{OGR2OGR} -t_srs EPSG:4326 -a_srs EPSG:4326 -f "GeoJSON" #{jsfn} #{shpfn}!
          File.open(jsfn) do |jsf|
            geojson = JSON.load(jsf)
            geojson['features'].first['properties'].each do |k,v|
              range = case v
                      when TrueClass, FalseClass then RDF::XSD.boolean
                      when Fixnum then RDF::XSD.integer
                      when Float then RDF::XSD.float
                      else RDF::XSD.string
                      end
              k = "#{self.title} #{k}" if k.downcase == 'type'
              self.source_properties << OpenMedia::DatasourceProperty.new(:label=>k, :range_uri=>range.to_s)
            end
            self.source_properties  << OpenMedia::DatasourceProperty.new(:label=>'geometry', :range_uri=>RDF::OM_CORE.GeoJson.to_s)
            self.save!

            geojson['features'].each do |feature|
              rows_parsed += 1
              raw_record = OpenMedia::RawRecord.new(:datasource=>self, :batch_serial_number=>batch_serial_number)
              self.source_properties.each {|sp| raw_record[sp.identifier] = feature['properties'][sp.label]}
              raw_record['geometry'] = feature['geometry']
              OpenMedia::RawRecord.database.bulk_save_doc(raw_record)
              OpenMedia::RawRecord.database.bulk_save if rows_parsed%500 == 0              
            end
            OpenMedia::RawRecord.database.bulk_save
          end              
        else
          raise "No .shp file found inside zip"
        end
      end
    elsif self.webservice_source?
      # Web Service code goes here!!
      raise "If this were implemented, I'd get the data from #{self.webservice_url}"
    end
  end


  def publish!
    # generate ctl from dataset and source definition
    ctl = "source :in, {:datasource=>'#{self.id}'}, ["+
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

  def webservice_source?
    source_type == WEBSERVICE_TYPE
  end
    

  def raw_records(view_opts={})
    OpenMedia::RawRecord.by_datasource_id({:key=>self.id}.merge(view_opts))
  end  

  def unpublished_raw_records(view_opts={})
    OpenMedia::RawRecord.by_unpublished({:key=>self.id}.merge(view_opts))
  end  
  
  def raw_record_count
    OpenMedia::RawRecord.by_datasource_id(:key=>self.id, :include_docs=>false)['rows'].size
  end

  def published_raw_record_count(view_opts={})
    OpenMedia::RawRecord.by_datasource_id_and_published(:startkey=>[self.id], :endkey=>[self.id, {}], :include_docs=>false)['rows'].size
  end
  

  def valid_for_publishing?
    false
  end

  def update_metadata(data={})
    md_data = {
      :creator => self.creator,
      :publisher => self.publisher,
      :language => 'en-US',
      :conformsto => rdfs_class,
      :title => rdfs_class.label,
      :description => rdfs_class.comment,
      :resourcetype => RDF::DCTYPE.Dataset
      }.merge(data)
      
      if metadata
        metadata.update!(md_data)
        puts "updated"
      else
        md = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreMetadataMetadata.for(RDF::METADATA.Metadata/"#{UUID.new.generate.gsub(/-/,'')}", md_data).save!
        self.metadata_uri = md.uri.to_s      
      end
  end



end
