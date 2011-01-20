class Schema::TypesController < ApplicationController
  before_filter :filter_empty_properties, :only=>[:create, :update]

  def new
    @domain = OpenMedia::Schema::Domain.get(params[:domain_id])
    @type = OpenMedia::Schema::Type.new
  end

  def new_property
    @property = OpenMedia::Schema::Property.new
    render :partial=>'property', :locals=>{:base_name=>'type[type_properties][]', :property=>@property}, :layout=>nil
  end

  def autocomplete
    startkey = params[:term].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'')
    @types = OpenMedia::Schema::Type.by_identifier(:startkey=>startkey, :endkey=>"#{startkey}\uffff")
    render :json=>@types.collect{|t| {:id=>t.id, :label=>"#{t.name} (#{t.qualified_name})", :value=>t.name} }
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

  def show
    @type = OpenMedia::Schema::Type.get(params[:id])
  end

  def edit
    @type = OpenMedia::Schema::Type.get(params[:id])
  end

  def update
    @type = OpenMedia::Schema::Type.get(params[:id])
    @type.type_properties.clear
    respond_to do |format|
      if @type.update_attributes(params[:type])
        flash[:notice] = 'Successfully updated Type.'
        format.html { redirect_to(schema_domain_type_path) }
        format.xml  { head :ok }
      else
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

private
  # remove properties which are totally blank  
  def filter_empty_properties
    if params[:type] && params[:type][:type_properties]
      params[:type][:type_properties] = params[:type][:type_properties].reject{|p| p.values.all?{|v| v.blank?}}
    end
  end    

end
