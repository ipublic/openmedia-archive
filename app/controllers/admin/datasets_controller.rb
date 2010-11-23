class Admin::DatasetsController < ApplicationController
  
  def index
    @datasets = OpenMedia::Dataset.search(params[:search])
  end
  
  def show
    @dataset = OpenMedia::Dataset.get(params[:id])
  end
  
  def new
    @dataset = OpenMedia::Dataset.new
    @dataset.metadata = OpenMedia::Metadata.new
  end
  
  def create
    @dataset = OpenMedia::Dataset.new(params[:dataset])

    if @dataset.save
      flash[:notice] = 'OpenMedia::Dataset successfully created.'
      redirect_to upload_admin_dataset_path(@dataset.class_name)
    else
      flash[:error] = 'Unable to create Dataset.'
      render :action => "new"
    end
  end
  
  def upload
    @dataset = OpenMedia::Dataset.get(params[:id])
  end
   
  def upload_file
    @dataset = OpenMedia::Dataset.get(params[:id])
    @dataset_update = OpenMedia::Dataset.new(params[:dataset])
    @attachment = params[:uploaded_file]
    
    @dataset.update_attributes_without_saving(
      :delimiter_character => @dataset_update["delimiter_character"],
      :column_header_row => @dataset_update["column_header_row"]
    )
    
    @dataset['_attachments'] ||= {}
    @dataset['_attachments'][@attachment.original_filename] = {
      'type' => @attachment.content_type.chomp,
      'data' => @attachment.read
    }
   
    if @dataset.save
      flash[:notice] = 'File successfully uploaded.'
      redirect_to import_admin_dataset_url(@dataset)
    else
      flash[:error] = 'Error uploading datafile.'
      render :action => "new"
    end
  end
  
  def import
    @dataset = OpenMedia::Dataset.get(params[:id])
    
    # Determine if attachment was added on latest revision
    @attachments = @dataset['_attachments']
    @attachments.each { |k, v| @attachment_name = k if (v['revpos'] == @dataset['_rev'].to_i) }

    if !@attachment_name.nil?
      @xtab = Ruport::Data::Table.parse(
          @dataset.fetch_attachment(@attachment_name),
          :has_names => @dataset.column_header_row,
          :csv_options => { :col_sep => @dataset.delimiter_character }
        )
    
      # Collect the property names
#      @dataset.properties ||= {}
      @xtab[0].attributes.each { |prop_name| @dataset.add_property(Property.new(:name => prop_name.to_s)) }
    end
  end
  
  def initialize_document
    @dataset = OpenMedia::Dataset.get(params[:id])
    @dataset_update = OpenMedia::Dataset.new(params[:dataset])
    @key_property = Property.new(params[:property])

    logger.debug  "****"
    logger.debug  "IN initialize_document"
    logger.debug "Dataset values: #{@dataset.inspect}"
    logger.debug "Dataset_update values: #{@dataset_update.inspect}"
    logger.debug "Property params: #{params[:property].inspect}"
    logger.debug "Key property name: #{@key_property.name}"
    logger.debug  "****"
    
    # Load the dataset properties array
    @dataset.update_attributes_without_saving(
      :properties => @dataset_update["properties"]
    )

    # Set the Unique ID property value
    @dataset.unique_id_property = @key_property.name unless @key_property.nil?

    # @dataset.delete("couchrest-type")
    # @dataset.delete("rev")
    
    if @dataset.save
      flash[:notice] = 'Successfully initialized Dataset properties.'
      redirect_to admin_datasets_path
    else
      flash[:error] = 'Error initializing Dataset properties.'
      render :action => "import"
    end

    if @dataset.initialize_document
    else
    end
  end
  
  def edit
    @dataset = Dataset.get(params[:id])

    unless @dataset.nil?
      @metadata = @dataset.metadata
    else
      flash[:error] = 'Dataset not found.'
      redirect_to(admin_datasets_url)
    end
  end
  
  def update
    @dataset = Dataset.get(params[:id])
    @updated_dataset = Dataset.new(params[:dataset])

    @revs = @dataset['_rev'] + ' ' + @updated_dataset['rev']

    if @dataset['_rev'].eql?(@updated_dataset.delete("rev"))
      @updated_dataset.delete("couchrest-type")
      
      @updated_dataset.metadata = Metadata.new(params[:metadata])

      respond_to do |format|
        if @dataset.update_attributes(@updated_dataset)
          flash[:notice] = 'Successfully updated Dataset.'
          format.html { redirect_to(admin_datasets_path) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @dataset.errors, :status => :unprocessable_entity }
        end
      end
    else
      # Document revision is out of sync
      flash[:notice] = 'Update conflict. Dataset has been updated elsewhere, reload Dataset page, then update again. ' + @revs
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dataset.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @dataset = Dataset.get(params[:id])
    
    unless @dataset.nil?
      @dataset.destroy
      redirect_to(admin_datasets_url)
    else
      flash[:error] = "Dataset not found. The Dataset could not be found, refresh the catalog list and try again."
      redirect_to(admin_datasets_url)
    end
  end
  

  
end
