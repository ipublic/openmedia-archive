class Admin::DatasetsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]

  def index
    @datasets = OpenMedia::Dataset.search(params[:search])
  end
  
  def show
    @dataset = OpenMedia::Dataset.get(params[:id])
#    @documents = @dataset.model.all
    @documents = []
    @documents << @dataset.model.first if @dataset.model.first
  end
  
  def new_upload
    @dataset = OpenMedia::Dataset.new
    @dataset.metadata = OpenMedia::Metadata.new
    @dataset.source = OpenMedia::Source.new(:column_separator=>',', :skip_lines=>0)
    @datasets = OpenMedia::Dataset.all
  end
  
  def new
    @dataset = OpenMedia::Dataset.new
    @dataset.metadata = OpenMedia::Metadata.new
    @dataset.source = OpenMedia::Source.new(:column_separator=>',', :skip_lines=>0)
  end

  def import_seed_data
    @dataset = OpenMedia::Dataset.get(params[:id])
    import_file = "/tmp/#{@dataset.identifier}-seed-data.csv"
    File.open(import_file, 'w') {|f| f.write(@dataset.read_attachment('seed_data'))}
    count = @dataset.import!(:file=>import_file)
    @dataset.delete_attachment('seed_data')
    @dataset.save!
    flash[:notice] = "Imported #{count} records into dataset #{@dataset.title}"
    redirect_to admin_dataset_path(@dataset.identifier)
  end

  def upload
    # either create new dataset and save seed data or do import on existing dataset
    data_file = params.delete(:data_file)
    seed_data_attachment = nil
    if params[:dataset_id]
      @dataset = OpenMedia::Dataset.get(params[:dataset_id])
      count = @dataset.import!(:file=>(data_file.respond_to?(:tempfile) ? data_file.tempfile.path : data_file.path))
      flash[:notice] = "Imported #{count} records into dataset #{@dataset.title}"      
      redirect_to admin_datasets_path
    elsif params[:dataset]
      @dataset = OpenMedia::Dataset.new(params[:dataset])

      if data_file
        # parse first line of file and setup properties
        has_header_row = params.delete(:has_header_row)
        data = FasterCSV.parse(data_file.read, {:col_sep=>@dataset.source.column_separator})

        if !@dataset.data_type
          @domain = OpenMedia::Schema::Domain.find(params[:domain_id])
          @type = OpenMedia::Schema::Type.new(:domain=>@domain, :name=>"#{@dataset.title} Type")
          property_names = []
          if has_header_row
            @dataset.source.skip_lines = 1
            property_names = data[0]
          else
            1.upto(data[0].size) {|i| property_names << "Column#{i}"}
          end
          property_names.each do |name|
            @type.type_properties << OpenMedia::Schema::Property.new(:name=>name, :expected_type=>OpenMedia::Schema::Domain.default_types.find_type('string'))
            @dataset.source.source_properties << OpenMedia::Schema::Property.new(:name=>name, :expected_type=>OpenMedia::Schema::Domain.default_types.find_type('string'))
          end
          @dataset.data_type = @type
        end
        
        data_file.rewind

        # this is a hack, but basically, save dataset once so that the Dataset#update_model_views callback runs before attachment is in there
        # otherwise, it gets base64 encoded twice
        @dataset.save        
        @dataset.create_attachment(:file=>(data_file.respond_to?(:tempfile) ? data_file.tempfile : data_file), :name=>'seed_data',
                                   :content_type=>data_file.content_type)
      end
      if @dataset.save
        redirect_to edit_admin_dataset_path(@dataset.identifier)
      else
        @datasets = OpenMedia::Dataset.all        
        render :action=>'new_upload'
      end
    else
      raise 'dataset_id or dataset parameters are required'
    end

  end  
  
  def create
    data_file = params[:dataset].delete(:data_file)
    
    @dataset = OpenMedia::Dataset.new(params[:dataset])
    
    if @dataset.save
      # this was here for Refine, commenting out for dataset workflow changes
      #if data_file
      #  data_file = data_file.respond_to?(:tempfile) ? data_file.tempfile : data_file
      #  @dataset.import_data_file!(data_file, :has_header_row=>has_header_row, :delimiter_character=>delimiter_character)
      #end

      respond_to do |format|
        format.html do
          flash[:notice] = 'Dataset successfully created.'
          redirect_to admin_datasets_path
        end

        format.json { render :json=>{id=>@dataset.identifier}, :status=>:created }
      end

    else
      respond_to do |format|
        format.html do
          flash[:error] = 'Unable to create Dataset.'
          render :action => "new"
        end

        format.json do
          render :text=>@dataset.errors.full_messages*"\n", :status=>400
        end
      end
    end
  end
     
  def edit
    @dataset = OpenMedia::Dataset.get(params[:id])    
    if @dataset.nil?
      flash[:error] = 'Dataset not found.'
      redirect_to(admin_datasets_url)
    end
  end
  
  def update
    @dataset = OpenMedia::Dataset.get(params[:id])
    @dataset.update_attributes_without_saving(params[:dataset])
    # @dataset.metadata.update_attributes_without_saving(params[:dataset])

    respond_to do |format|    
      if @dataset.save!
        flash[:notice] = 'Successfully updated Dataset.'
        format.html { redirect_to(admin_datasets_path) }
        format.xml  { head :ok }    
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dataset.errors, :status => :unprocessable_entity }
      end
    end      
  end

  def new_property
    @property = OpenMedia::Property.new
    render :partial=>'property', :locals=>{:base_name=>params[:base_name], :property=>@property}, :layout=>nil
  end


  def destroy
    @dataset = OpenMedia::Dataset.get(params[:id])
    
    unless @dataset.nil?
      @dataset.destroy
      redirect_to(admin_datasets_path)
    else
      flash[:error] = "Dataset not found. The Dataset could not be found, refresh the catalog list and try again."
      redirect_to(admin_datasets_path)
    end
  end
  

  def seed_properties
    render :layout => nil
  end

  # def extract_seed_properties
  #     
  #   data_file = params[:data_file].respond_to?(:tempfile) ? params[:data_file].tempfile :
  #                            params[:data_file]
  #   column_separator = params[:column_separator]
  #   if column_separator =~ /^\\/
  #     begin
  #       column_separator = eval('"' + params[:column_separator] + '"')
  #     rescue; end
  #   end
  # 
  #   rtable = Ruport::Data::Table.parse(data_file, :has_names=>true,
  #                                       :csv_options => { :col_sep => column_separator })
  #   @properties = rtable[0].attributes.collect{|name| OpenMedia::Property.new(:name=>name)}
  #   render :layout => nil
  # end
  
end
