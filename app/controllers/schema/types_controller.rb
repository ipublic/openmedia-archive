class Schema::TypesController < ApplicationController

  def new
    @domain = OpenMedia::Schema::Domain.get(params[:domain_id])
    @type = OpenMedia::Schema::Type.new
  end

  def create
    @domain = OpenMedia::Schema::Domain.get(params[:domain_id])
    
    @type = OpenMedia::Schema::Type.new(params[:type])
    @type.domain = @domain

    if @type.save
      flash[:notice] = 'Type successfully created.'
      redirect_to(schema_domain_path @domain)
    else
      flash.now[:error] = 'Unable to create Type.'
      render :action => "new"
    end
  end

  def edit
    @type = OpenMedia::Schema::Type.get(params[:id])
  end

  def update
    @type = OpenMedia::Schema::Type.get(params[:id])
    @updated_type = OpenMedia::Schema::Type.new(params[:type])

    @revs = @type['_rev'] + ' ' + @updated_type['rev']

    if @type['_rev'].eql?(@updated_type.delete("rev"))
      @updated_type.delete("couchrest-type")

      respond_to do |format|
        if @type.update_attributes(@updated_type)
          flash[:notice] = 'Successfully updated Type.'
          format.html { redirect_to(schema_domains_path) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @type.errors, :status => :unprocessable_entity }
        end
      end
    else
      # Document revision is out of sync
      flash[:notice] = 'Update conflict. Type has been updated elsewhere, reload Type page, then update again. ' + @revs
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @type.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @type = OpenMedia::Schema::Type.get(params[:id])

    unless @type.nil?
      @type.destroy
      redirect_to(schema_domains_path)
    else
      flash[:error] = "Type not found. The @type could not be found, refresh the catalog list and try again."
      redirect_to(schema_domains_path)
    end
  end
end
