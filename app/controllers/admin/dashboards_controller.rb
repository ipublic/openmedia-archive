class Admin::DashboardsController < Admin::BaseController
  
  def index
    @dashboards = OpenMedia::Dashboard.all
  end
  
  def show
    @dashboard = OpenMedia::Dashboard.get(params[:id])
  end

  def new
    @dashboard = OpenMedia::Dashboard.new
    @dashboard_group = OpenMedia::DashboardGroup.new
  end

  def new_group
    render :partial=>'form_dashboard_group', :locals=> { :group=>OpenMedia::DashboardGroup.new }
  end

  def new_measure
    render :partial=>'form_measure', :locals=> { :measure=>{ } }
  end
  

  def create
    @dashboard = OpenMedia::Dashboard.new(params[:dashboard])

    if @dashboard.save
      flash[:notice] = 'Successfully created Dashboard.'
      redirect_to(admin_dashboard_path(@dashboard))
    else
      flash[:error] = 'Unable to create Dashboard.'
      render :action => "new"
    end
  end

  def edit
    @dashboard = OpenMedia::Dashboard.get(params[:id])
    @dashboard_groups = @dashboard.groups
  end
  
  def update
    @dashboard = OpenMedia::Dashboard.get(params[:id])

    respond_to do |format|
      if @dashboard.save
        flash[:notice] = 'Successfully updated Dashboard.'
        format.html { redirect_to(admin_dashboard_path) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error updating Dashboard."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dashboard.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  # DELETE /dashboards/:id
  def destroy
    @dashboard = OpenMedia::Dashboard.get(params[:id])
    unless @dashboard.nil?
      @dashboard.destroy
      redirect_to(admin_dashboards_url)
    else
      flash[:error] = "The Dashboard could not be found, refresh the Dashboard list and try again."
      redirect_to(admin_dashboards_url)
    end
  end
  
end
