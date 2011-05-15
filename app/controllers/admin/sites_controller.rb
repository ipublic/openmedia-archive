class Admin::SitesController < Admin::BaseController
  include GoogleMapsHelper
  
  def new
    @site = OpenMedia::Site.new
    @site.municipality = OpenMedia::NamedPlace.new
  end
  
  def create
    @site = OpenMedia::Site.new(params[:site])

    if @site.save
      flash[:notice] = 'Site successfully created.'
      if session[:after_site_created]
        return_to = session[:after_site_created]
        session[:after_site_created] = nil
        redirect_to(return_to)
      else
        redirect_to(admin_site_path)
      end
    else
      flash[:error] = 'Unable to create Site.'
      render :action => "new"
    end
  end

  def show
    @site = current_site
    if @site.nil?
      redirect_to new_admin_site_path
    else
      @municipality = @site.municipality
 
    # Load GoogleMaps
      initialize_map
      @map.zoom = 10
      @map.center = @site.ll
      @map.markers << @site.geomarker
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @site }
      end
    end
  end

  def edit
    @site = current_site
  end

  def update
    @site = current_site
    @site.attributes=params[:site]
    @site.municipality = OpenMedia::InferenceRules::GeographicName.find_by_name_and_id(params[:site][:municipality][:name],
                                                                                       params[:site][:municipality][:source_id].to_i)
    @site.municipality.description = params[:site][:municipality][:description]
    respond_to do |format|
      if @site.save
        flash[:notice] = 'Successfully updated site settings.'
        format.html { redirect_to(admin_site_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
