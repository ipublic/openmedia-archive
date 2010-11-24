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
      redirect_to upload_admin_dataset_path(@dataset.identifier)
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
    @dataset.update_attributes_without_saving(params[:dataset])
    @dataset.initialize_properties!(params[:uploaded_file].respond_to?(:tempfile) ? params[:uploaded_file].tempfile :
                             params[:uploaded_file])

    if @dataset.dataset_properties.size == 0
      flash[:error] = 'Could not get property names from source file'
      render :action => 'upload'      
    else
      flash[:notice] = 'File successfully uploaded.'
      redirect_to new_import_admin_dataset_path(@dataset.identifier)      
    end
  end
  
  def new_import
    @dataset = OpenMedia::Dataset.get(params[:id])
    @property_options = @dataset.dataset_properties.collect{|p| [p.name, p.name]}
    @record = @dataset.get_sample_record(0)    
  end
  
  def import
    @dataset = OpenMedia::Dataset.get(params[:id])
    @dataset.update_attributes(params[:dataset])

    
    if @dataset.import_attachment!(OpenMedia::Dataset::SAMPLE_DATA_ATTACHMENT_NAME)
      flash[:notice] = 'Successfully initialized Dataset properties.'
      redirect_to admin_datasets_path
    else
      flash[:error] = 'Error initializing Dataset properties.'
      render :action => "import"
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
