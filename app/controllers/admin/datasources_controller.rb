class Admin::DatasourcesController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]

  def index
    @datasources = OpenMedia::Datasource.search(params[:search])
  end
  
  def show
    @datasource = OpenMedia::Datasource.get(params[:id])
    @documents = []
    model = @datasource.rdfs_class.spira_resource
    model.default_source(@datasource.rdfs_class.skos_concept.collection.repository)
    @documents << model.each.first if @datasource.rdfs_class
  end
  
  def new_upload
    @datasource = OpenMedia::Datasource.new(:column_separator=>',', :skip_lines=>0)
    @datasources = OpenMedia::Datasource.all
    @vcards = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource.each.to_a
  end
  
  def new
    @datasource = OpenMedia::Datasource.new(:column_separator=>',', :skip_lines=>0)
    @datasource.metadata = OpenMedia::Metadata.new
  end

  def import_seed_data
    @datasource = OpenMedia::Datasource.get(params[:id])
    import_file = "/tmp/#{@datasource.id}-seed-data.csv"
    File.open(import_file, 'w') {|f| f.write(@datasource.read_attachment('seed_data'))}
    count = @datasource.import!(:file=>import_file)
    @datasource.delete_attachment('seed_data')
    @datasource.save!
    flash[:notice] = "Imported #{count} records into datasource #{@datasource.title}"
    redirect_to admin_datasource_path(@datasource)
  end

  def upload
    # either create new datasource and save seed data or do import on existing datasource
    data_file = params.delete(:data_file)
    seed_data_attachment = nil
    if params[:datasource_id]
      @datasource = OpenMedia::Datasource.get(params[:datasource_id])
      count = @datasource.import!(:file=>(data_file.respond_to?(:tempfile) ? data_file.tempfile.path : data_file.path))
      flash[:notice] = "Imported #{count} records into datasource #{@datasource.title}"      
      redirect_to admin_datasources_path
    elsif params[:datasource]
      @datasource = OpenMedia::Datasource.new(params[:datasource])
      if data_file
        # parse first line of file and setup properties
        has_header_row = params.delete(:has_header_row)
        data = FasterCSV.parse(data_file.read, {:col_sep=>@datasource.column_separator})

        if @datasource.rdfs_class_uri.blank?
          @collection = OpenMedia::Schema::SKOS::Collection.for(params[:collection_uri])
          if @collection.exists?
            @class = OpenMedia::Schema::RDFS::Class.create_in_site!(OpenMedia::Site.instance, :label=>@datasource.title)
            @collection.members << @class.uri
            @collection.save!
            property_names = []
            if has_header_row
              @datasource.skip_lines = 1
              property_names = data[0]
            else
              1.upto(data[0].size) {|i| property_names << "Column#{i}"}
            end
            property_names.each do |name|
              @class.properties << OpenMedia::Schema::RDF::Property.create_in_class!(@class, :label=>name, :range=>RDF::XSD.string)
              @datasource.source_properties << OpenMedia::DatasourceProperty.new(:label=>name, :range_uri=>RDF::XSD.string.to_s)
            end
            @class.save!          
            @datasource.rdfs_class_uri = @class.uri.to_s
          
          else
            @datasource.errors.add(:base, "Please select an existing Class or choose a Collection to create new Class in")
          end            
        end
      else
        @datasource.errors.add(:base, "Please select a file")
      end

      if @datasource.errors.size == 0
        if data_file
          data_file.rewind        
          @datasource.create_attachment(:file=>(data_file.respond_to?(:tempfile) ? data_file.tempfile : data_file), :name=>'seed_data',
                                        :content_type=>data_file.content_type)            
        end
        if @datasource.save
          redirect_to edit_admin_datasource_path(@datasource)
        else
          @datasources = OpenMedia::Datasource.all
          @vcards = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource.each.to_a          
          render :action=>'new_upload'
        end
      end
      
    else
      raise 'datasource_id or datasource parameters are required'
    end
  end  
  
  def create
    data_file = params[:datasource].delete(:data_file)
    
    @datasource = OpenMedia::Datasource.new(params[:datasource])
    
    if @datasource.save
      # this was here for Refine, commenting out for datasource workflow changes
      #if data_file
      #  data_file = data_file.respond_to?(:tempfile) ? data_file.tempfile : data_file
      #  @datasource.import_data_file!(data_file, :has_header_row=>has_header_row, :delimiter_character=>delimiter_character)
      #end

      respond_to do |format|
        format.html do
          flash[:notice] = 'Datasource successfully created.'
          redirect_to admin_datasources_path
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
     
  def edit
    @datasource = OpenMedia::Datasource.get(params[:id])
    @vcards = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource.each.to_a    
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
          @vcards = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource.each.to_a                  
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
  

  def seed_properties
    render :layout => nil
  end
  
end
