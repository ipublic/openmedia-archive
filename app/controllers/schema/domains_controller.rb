class Schema::DomainsController < ApplicationController
  
  def index
    @domains = OpenMedia::Schema::Domain.all
    
    respond_to do |format|
      format.html
      format.json { render :json=>@catalogs.to_json }
    end
  end
  
  def show
    @domain = OpenMedia::Schema::Domain.get(params[:id])
    @types = OpenMedia::Schema::Type.find_by_domain_id(@domain.identifier)
    @types ||= []
    
    respond_to do |format|
      format.html
      format.json { render :json=>@catalogs.to_json }
    end
  end
  
  def new
    @domain = OpenMedia::Schema::Domain.new
  end
  
  def create
    @domain = OpenMedia::Schema::Domain.new(params[:domain])

    if @domain.save
      flash[:notice] = 'Domain successfully created.'
      redirect_to(schema_domains_path)
    else
      flash.now[:error] = 'Unable to create Domain.'
      render :action => "new"
    end
  end
  
  def edit
    @domain = OpenMedia::Schema::Domain.get(params[:id])
  end
  
  def update
    @domain = OpenMedia::Schema::Domain.get(params[:id])
    @updated_domain = OpenMedia::Schema::Domain.new(params[:domain])

    @revs = @domain['_rev'] + ' ' + @updated_domain['rev']

    if @domain['_rev'].eql?(@updated_domain.delete("rev"))
      @updated_domain.delete("couchrest-type")

      respond_to do |format|
        if @domain.update_attributes(@updated_domain)
          flash[:notice] = 'Successfully updated Domain.'
          format.html { redirect_to(schema_domains_path) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @domain.errors, :status => :unprocessable_entity }
        end
      end
    else
      # Document revision is out of sync
      flash[:notice] = 'Update conflict. Domain has been updated elsewhere, reload Domain page, then update again. ' + @revs
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @domain.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @domain = OpenMedia::Schema::Domain.get(params[:id])
    
    unless @domain.nil?
      @domain.destroy
      redirect_to(schema_domains_path)
    else
      flash[:error] = "Domain not found. The Domain could not be found, refresh the catalog list and try again."
      redirect_to(schema_domains_path)
    end
  end
  
end
