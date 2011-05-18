class Admin::MapsController < ApplicationController
  include GoogleMapsHelper

  def index
    @maps = OpenMedia::Map.all
  end
  
  def feature_ajax
    render :text => "Success"
  end

  def show
    @map = OpenMedia::Map.get(params[:id])
    
    # Load GoogleMaps
    initialize_gmap
    @gmap.zoom = 11
      
    # Generate the Map Pins
    @recs = OpenMedia::Schema.get_records(@map.feature_class)

    p = OpenMedia::Site.first.municipality.geometries.first
    pos = p['coordinates'].reverse if p['type'] == "Point"
    @gmap.markers << Cartographer::Gmarker.new(:position => pos)
    
    @markers = []
    @recs.each do |r|
      pos = r['geometry']['coordinates'].reverse if r['geometry']['type'] == "Point"
      mrk = Cartographer::Gmarker.new(
                                                 # :icon => @icon,
                                                 # :marker_type => "Organization", 
                                                 :position => pos)
      @markers << mrk
    end
    @gmap.markers = @markers
    # 
#    @recs = OpenMedia::Site.first.to_a # OpenMedia::Schema.get_records(@map.feature_class)

    # r = OpenMedia::Site.first.municipality.geometries.first
    # 
    # pos = r['coordinates'].reverse if r['type'] == "Point"
#    prop_link = link_text = 'Show on map',, options = {})
#    prop_html = [{:title => "tab1", :html => "<p>1</p>"}, {:title => "tab2", :html => "<p>2</p>"}]
#     prop_html = "<p>1</p>"
#     prop_link = "/some_link"
#     iwin = Cartographer::InfoWindow.new(:content => '<p>You <i>clicked</i> my marker</p>')
#     
#     @icon = Cartographer::Gicon.new()
#     @gmap.icons << @icon
# #    @gmap.marker_mgr = true
# 
#     @gmap.markers << Cartographer::Gmarker.new(
#                                                :marker_type => "Organization",
#                                                :icon => @icon,
#                                                :info_window => '<p>here is the content</p>',
# #                                               :info_window_url => prop_link,
# #                                               :info_window => '<p>You <i>clicked</i> my marker</p>'.html_safe,
#                                                :position => pos)
#     
#     
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
