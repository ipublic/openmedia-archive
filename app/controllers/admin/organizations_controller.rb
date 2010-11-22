class Admin::OrganizationsController < ApplicationController
  # GET /organizations
  def index
    @organizations = OpenMedia::Organization.by_name
  end

  # GET /organizations/:id
  def show
    # Using CouchDB -- use Get method rather then Find used by ActiveRecord
    @organization = OpenMedia::Organization.get(params[:id])
    
    unless @organization.nil?
#        @datasets = Dataset.view_by_creator_organization_id(:key => @organization['_id'])
    else
      flash[:error] = "Organization not found for ID=#{params[:id]}"
      redirect_to(admin_organizations_url)
    end
  end

  # GET /organizations/new
  def new
    @organization = OpenMedia::Organization.new(:address=>OpenMedia::Address.new,
                                                :phone=>OpenMedia::Phone.new,
                                                :contact=>OpenMedia::Contact.new)
  end

  # POST /organizations
  def create
    @organization = OpenMedia::Organization.new(params[:organization])
    @organization.phones = (params[:phone])
    @organization.addresses = (params[:address])
    
    @organization.contacts = (params[:contact])

    if @organization.save
      flash[:notice] = 'Organization successfully created.'
      redirect_to admin_organization_path(@organization)
    else
      flash[:error] = 'Unable to create Organization.'
      logger.debug(@organization.errors.inspect)
      render :action => "new"
    end
  end

  # GET /organizations/:id/edit
  def edit
    @organization = OpenMedia::Organization.get(params[:id])
    unless @organization.nil?
      @contact = @organization.contacts[0]
      @address ||= []
#      @address = @organization.addresses[0]
    else
      flash[:error] = 'Organization not found.'
      redirect_to(admin_organizations_url)
    end
  end

  # PUT /organizations/:id
  def update
    @organization = OpenMedia::Organization.get(params[:id])
    @updated_organization = OpenMedia::Organization.new(params[:organization])
    
    @revs = @organization['_rev'] + ' ' + @updated_organization['rev']

    if @organization['_rev'].eql?(@updated_organization.delete("rev"))
      @updated_organization.delete("couchrest-type")
      @updated_organization.contacts = Contact.new(params[:contact])
      @updated_organization.addresses = Address.new(params[:address])

      respond_to do |format|
        if @organization.update_attributes(@updated_organization)
          flash[:notice] = 'Successfully updated Organization.'
          format.html { redirect_to(admin_organizations_path) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
        end
      end
    else
      # Document revision is out of sync
      flash[:notice] = 'Update conflict. This Organization has been updated elsewhere, reload Organziztion page, then update again. ' + @revs
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # DELETE /organizations/:id
  def destroy
    @organization = OpenMedia::Organization.get(params[:id])
    unless @organization.nil?
      @organization.destroy
      redirect_to(admin_organizations_url)
    else
      flash[:error] = "Organization not found. The organization could not be found, refresh the organization list and try again."
      redirect_to(admin_organizations_url)
    end
  end  
end
