# require 'csv'
require_dependency 'csv'
require 'tmpdir'

class Admin::DatasourcesController < Admin::BaseController

  skip_before_filter :verify_authenticity_token, :only => [:create]

  def index
    @datasources = current_site.datasources
  end

  def new
    @datasource = OpenMedia::Datasource.new(:column_separator=>',', :skip_lines=>0)
  end  
  
  def show
    @datasource = OpenMedia::Datasource.get(params[:id])
    @documents = []
    if @datasource.rdfs_class
      model = @datasource.rdfs_class.spira_resource
      model.default_source(@datasource.rdfs_class.skos_concept.collection.repository)
    end
  end
  
  def create
    @datasource = OpenMedia::Datasource.new(params[:datasource])
    
    if @datasource.save
      logger.debug("saved #{@datasource.id}")
      # this was here for Refine, commenting out for datasource workflow changes
      #if data_file
      #  data_file = data_file.respond_to?(:tempfile) ? data_file.tempfile : data_file
      #  @datasource.import_data_file!(data_file, :has_header_row=>has_header_row, :delimiter_character=>delimiter_character)
      #end
      current_site.datasources << @datasource
      current_site.save!
      
      if @datasource.textfile_source? && params[:textfile]
        @datasource.initial_import!(params[:textfile])
      elsif @datasource.shapefile_source? && params[:shapefile] && params[:shapefile].content_type =~ /(zip|ZIP)$/
        @datasource.initial_import!(params[:shapefile])
      elsif @datasource.webservice_source?
        @datasource.initial_import!
      end

      respond_to do |format|
        format.html do
          flash[:notice] = 'Datasource successfully created.'
          redirect_to admin_datasource_path(@datasource)
        end

        format.json { render :json=>{id=>@datasource.identifier}, :status=>:created }
      end

    else
      respond_to do |format|
        format.html do
          flash[:error] = 'Unable to create Datasource.'
          render :action => "new"
        end

        format.json do
          render :text=>@datasource.errors.full_messages*"\n", :status=>400
        end
      end
    end
  end

  def raw_records
    @datasource = OpenMedia::Datasource.find(params[:id])
    count = @datasource.raw_record_count
    records = @datasource.raw_records(:limit=>params[:iDisplayLength], :skip=>params[:iDisplayStart])
    render :json=>{
      :sEcho=>params[:sEcho],
      :aaData=>records.collect{|rr| @datasource.source_properties.collect{|p| rr[p.identifier]}},
      :iTotalRecords=>count,
      :iTotalDisplayRecords=>count
    }
  end

     
  def edit
    @datasource = OpenMedia::Datasource.get(params[:id])
    # @vcards = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource.each.to_a
    if @datasource.nil?
      flash[:error] = 'Datasource not found.'
      redirect_to(admin_datasources_url)
    end
  end
  
  def update
    @datasource = OpenMedia::Datasource.get(params[:id])
    @datasource.update_attributes_without_saving(params[:datasource])
    # @datasource.metadata.update_attributes_without_saving(params[:datasource])

    respond_to do |format|    
      if @datasource.save!
        flash[:notice] = 'Successfully updated Datasource.'
        format.html { redirect_to(admin_datasources_path) }
        format.xml  { head :ok }    
      else
        format.html do
          # @vcards = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource.each.to_a
          render :action => "edit"
        end
        format.xml  { render :xml => @datasource.errors, :status => :unprocessable_entity }
      end
    end      
  end

  def new_property
    @property = OpenMedia::DatasourceProperty.new
    render :partial=>'datasource_property', :locals=>{ :property=>@property }
  end

  def publishing
    @datasource = OpenMedia::Datasource.get(params[:id])
    @collections = om_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}
    @collections.concat(current_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}) unless current_site = om_site        
  end

  def publish
    @datasource = OpenMedia::Datasource.get(params[:id])
    params[:datasource].delete(:source_properties)  # just discard transformation data for now
    @datasource.update_attributes_without_saving(params[:datasource])    

    # create rdfs class with same properties/typea as datasource
    @collection = OpenMedia::Schema::SKOS::Collection.for(params[:collection_uri])
    if @datasource.rdfs_class_uri.blank? && @collection.exists?
      @class = OpenMedia::Schema::RDFS::Class.create_in_site!(current_site, :label=>@datasource.title, :comment=>params[:datasource][:metadata][:description])
      @collection.members << @class.uri
      @collection.save!
      @datasource.source_properties.each_with_index do |prop,idx|
        @class.properties << OpenMedia::Schema::RDF::Property.create_in_class!(@class, :label=>prop.label, :range=>RDF::URI.new(prop.range_uri))
      end
      @class.save!          
      @datasource.rdfs_class_uri = @class.uri.to_s
    end    

    @datasource.update_metadata(params[:datasource][:metadata])    
    @datasource.save!
    @datasource.publish!
    flash[:notice] = 'Dataset Published Successfully'
    redirect_to admin_datasource_path(@datasource)
  end


  def destroy
    @datasource = OpenMedia::Datasource.get(params[:id])
    
    unless @datasource.nil?
      @datasource.destroy
      redirect_to(admin_datasources_path)
    else
      flash[:error] = "The Datasource could not be found, refresh the catalog list and try again."
      redirect_to(admin_datasources_path)
    end
  end

  def upload
    # either create new datasource and save seed data or do import on existing datasource
    textfile = params.delete(:textfile)
    shapefile = params.delete(:shapefile)
    datafile = textfile || shapefile    
    seed_data_attachment = nil
    if params[:datasource_id]
      @datasource = OpenMedia::Datasource.get(params[:datasource_id])
      count = @datasource.import!(:file=>(datafile.respond_to?(:tempfile) ? datafile.tempfile.path : datafile.path))
      flash[:notice] = "Imported #{count} records into datasource #{@datasource.title}"      
      redirect_to admin_datasources_path
    elsif params[:datasource]      
      @datasource = OpenMedia::Datasource.new(params[:datasource])
      properties = []
      if @datasource.textfile_source? && textfile
        # parse first line of file and setup properties
        has_header_row = params.delete(:has_header_row)
        data = FasterCSV.parse(textfile.read, {:col_sep=>@datasource.column_separator})
        if has_header_row
          @datasource.skip_lines = 1
          properties = data[0].collect{|pn| {:label=>pn, :range=>RDF::XSD.string}}
        else
          1.upto(data[0].size) {|i| properties << {:label=>"Column#{i}", :range=>RDF::XSD.string}}
        end
        textfile.rewind        
        @datasource.create_attachment(:file=>(textfile.respond_to?(:tempfile) ? textfile.tempfile : textfile), :name=>'seed_data',
                                        :content_type=>textfile.content_type)            
        
      elsif @datasource.shapefile_source? && shapefile
        if shapefile.content_type =~ /(zip|ZIP)$/
          Dir.mktmpdir do |temp_dir|
            `#{UNZIP} #{shapefile.path} -d #{temp_dir}`
            shpfn = Dir.glob(File.join(temp_dir,'*.shp')).first
            if shpfn
              jsfn = shpfn.gsub(/\.shp/,'.js')
              %x!#{OGR2OGR} -t_srs EPSG:4326 -a_srs EPSG:4326 -f "GeoJSON" #{jsfn} #{shpfn}!
              File.open(jsfn) do |jsf|
                geojson = JSON.load(jsf)
                properties = geojson['features'].first['properties'].collect do |k,v|
                  range = case v
                            when TrueClass, FalseClass then RDF::XSD.boolean
                            when Fixnum then RDF::XSD.integer
                            when Float then RDF::XSD.float
                            else RDF::XSD.string
                          end
                  {:label=>k, :range=>range}
                end
                properties << {:label=>'geometry', :range=>RDF::OM_CORE.GeoJson}
                jsf.rewind
                @datasource.create_attachment(:file=>jsf, :name=>'seed_data',
                                              :content_type=>'application/json')            
                
              end              
            else
              @datasource.errors.add(:shapefile, "No .shp file found inside zip")
            end

          end
        else
          @datasource.errors.add(:shapefile, "Please select a zip file")
        end
      else
        @datasource.errors.add(:base, "Please select a file")
      end

      if @datasource.errors.size == 0 &&@datasource.rdfs_class_uri.blank?
        @collection = OpenMedia::Schema::SKOS::Collection.for(params[:collection_uri])
        if @collection.exists?
          @class = OpenMedia::Schema::RDFS::Class.create_in_site!(current_site, :label=>@datasource.title)
          @collection.members << @class.uri
          @collection.save!
          properties.each_with_index do |prop,idx|
            prop[:label] = "Column#{idx+1}" if prop[:label].nil?
            prop[:label] = "#{@class.label} #{prop[:label]}" if prop[:label].downcase=='type'
            prop[:label] = "Col #{prop[:label]}" if prop[:label] =~ /^\d*$/              
            @class.properties << OpenMedia::Schema::RDF::Property.create_in_class!(@class, :label=>prop[:label], :range=>prop[:range])
            @datasource.source_properties << OpenMedia::DatasourceProperty.new(:label=>prop[:label], :range_uri=>RDF::XSD.string.to_s)
          end
          @class.save!          
          @datasource.rdfs_class_uri = @class.uri.to_s
          
        else
          @datasource.errors.add(:base, "Please select an existing Class or choose a Collection to create new Class in")
        end
      end

      if @datasource.errors.size == 0
        if @datasource.save
          current_site.datasources << @datasource; current_site.save
          redirect_to edit_admin_datasource_path(@datasource)
        else
          @datasources = OpenMedia::Datasource.all
          # @vcards = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource.each.to_a
          render :action=>'new_upload'
        end
      else
        @datasources = OpenMedia::Datasource.all
         # @vcards = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource.each.to_a
        render :action=>:new_upload
      end
      
    else
      raise 'datasource_id or datasource parameters are required'
    end
  end  
  
end
