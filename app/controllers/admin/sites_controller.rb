class Admin::SitesController < ApplicationController
  
  def new
    @site = OpenMedia::Site.new
    @site.gnis = OpenMedia::Gnis.new
  end
  
  def create
    @site = OpenMedia::Site.new(params[:site])
    @site.gnis = OpenMedia::Gnis.new(params[:gnis])

    if @site.save
      flash[:notice] = 'Site successfully created.'
      redirect_to(admin_site_path)
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
      @gnis = @site.gnis
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @site }
      end
    end
  end

  def edit
    @site = OpenMedia::Site.first
    @gnis = @site.gnis
  end

  def update
    @site = OpenMedia::Site.first
    @updated_site = OpenMedia::Site.new(params[:site])
    
    @revs = @site['_rev'] + ' ' + @updated_site['rev']
    
    if @site['_rev'].eql?(@updated_site.delete("rev"))
      @updated_site.delete("couchrest-type")
      @updated_site.gnis = OpenMedia::Gnis.new(params[:gnis])

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
