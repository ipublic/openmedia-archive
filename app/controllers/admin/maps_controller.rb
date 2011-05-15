class Admin::MapsController < ApplicationController
  include GoogleMapsHelper

  def index
    @maps = OpenMedia::Map.all
  end

  def show
    @map = OpenMedia::Map.get(params[:id])
    
    # Load GoogleMaps
      initialize_map
      # @map.zoom = 10
      # @map.center = @site.ll
      # @map.markers << @site.geomarker
  end

  def new
    @map = OpenMedia::Map.new
  end

  def create
    @map = OpenMedia::Map.new(params[:map])

    if @map.save
      flash[:notice] = 'Successfully created Map.'
      redirect_to(admin_map_path)
    else
      flash[:error] = 'Unable to create Map.'
      render :action => "new"
    end
  end

  def edit
    @map = OpenMedia::Map.get(params[:id])
  end

  def update
    @map = OpenMedia::Map.get(params[:id])

    respond_to do |format|
      if @map.save
        flash[:notice] = 'Successfully updated Map.'
        format.html { redirect_to(admin_map_path) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error updating Map."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @map.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @map = OpenMedia::Map.get(params[:id])
    unless @map.nil?
      @map.destroy
      redirect_to(admin_maps_url)
    else
      flash[:error] = "The Map could not be found, refresh the Map list and try again."
      redirect_to(admin_maps_url)
    end
  end


end
