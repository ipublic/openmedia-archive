class Admin::SitesController < ApplicationController

  before_filter :authenticate_admin!
  
  def new
    @site = OpenMedia::Site.new
    @site.municipality = OpenMedia::NamedPlace.new
  end
  
  def create
    @site = OpenMedia::Site.new(params[:site])
    @site.municipality = OpenMedia::NamedPlace.new(params[:named_place])

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
    @site = OpenMedia::Site.first
    if @site.nil?
      redirect_to new_admin_site_path
    else
      @municipality = @site.municipality
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @site }
      end
    end
  end

  def edit
    @site = OpenMedia::Site.first
    @municipality = @site.municipality
  end

  def update
    @site = OpenMedia::Site.first
    @updated_site = OpenMedia::Site.new(params[:site])
    
    @revs = @site['_rev'] + ' ' + @updated_site['rev']
    
    if @site['_rev'].eql?(@updated_site.delete("rev"))
      @updated_site.delete("couchrest-type")
      @updated_site.municipality = OpenMedia::NamedPlace.new(params[:open_media][:named_place])

      respond_to do |format|
#        if @site.update_attributes(params[:site])
        if @site.update_attributes(@updated_site)
          flash[:notice] = 'Successfully updated site settings.'
          format.html { redirect_to(admin_site_path) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
        end
      end
    else
      # Document revision is out of sync
      flash[:notice] = 'Update conflict. Site settings have been updated elsewhere, reload Site page, then update again. ' + @revs
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
