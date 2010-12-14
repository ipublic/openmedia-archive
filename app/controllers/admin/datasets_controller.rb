require 'ruport'

class Admin::DatasetsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]

  def index
    @datasets = OpenMedia::Dataset.search(params[:search])
  end
  
  def show
    @dataset = OpenMedia::Dataset.get(params[:id])
  end
  
  def new
    @dataset = OpenMedia::Dataset.new
    @dataset.metadata = OpenMedia::Metadata.new
    @dataset.source = OpenMedia::Source.new(:column_separator=>',', :skip_lines=>0)
  end
  
  def create
    data_file = params[:dataset].delete(:data_file)
    
    @dataset = OpenMedia::Dataset.new(params[:dataset])
    
    if @dataset.save
      if data_file
        data_file = data_file.respond_to?(:tempfile) ? data_file.tempfile : data_file
        @dataset.import_data_file!(data_file, :has_header_row=>has_header_row, :delimiter_character=>delimiter_character)
      end

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

  def extract_seed_properties
      
    data_file = params[:data_file].respond_to?(:tempfile) ? params[:data_file].tempfile :
                             params[:data_file]
    rtable = Ruport::Data::Table.parse(data_file, :has_names=>true,
                                        :csv_options => { :col_sep => ',' })
    @properties = rtable[0].attributes.collect{|name| OpenMedia::Property.new(:name=>name)}
    render :layout => nil
  end
  
end
