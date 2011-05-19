class Admin::Schema::ClassesController < Admin::BaseController

  before_filter :load_objects
  before_filter :filter_empty_properties, :only=>[:create, :update]  

  helper_method :rdf_id
  
  def autocomplete
    startkey = params[:term].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'')
    @uris = OpenMedia::Schema::RDFS::Class.prefix_search(startkey)
    render :json=>@uris.collect{|u| {:id=>u.to_s, :label=>u.to_s, :value=>(u.fragment || u.path.split('/').last)} }    
  end

  def new
    @class = OpenMedia::Schema::RDFS::Class.new
  end

  def show
    @class_uri = RDF::OM_DATA[params[:id]]
    @class_def = OpenMedia::Schema.get_class_definition(@class_uri.to_s)
  end


  def new_property
    @property = OpenMedia::Schema::RDF::Property.new
    render :partial=>'property', :locals=>{:base_name=>'class[properties][]', :property=>@property}, :layout=>nil
  end

  def create
    begin
      properties_params = params[:class].delete(:properties)
      @class = OpenMedia::Schema::RDFS::Class.create_in_site!(current_site, params[:class])
      @collection.members << @class.uri
      @collection.save!
      if properties_params
        properties_params.each do |pp|
          pp[:range] = RDF::URI.new(pp[:range]) unless pp[:range].blank?
          @class.properties << OpenMedia::Schema::RDF::Property.create_in_class!(@class, pp)
        end
      end
      @class.save!
      redirect_to admin_schema_collection_path(rdf_id(@collection))
    rescue Exception => e
      flash[:error] = e.to_s
      @class = OpenMedia::Schema::RDFS::Class.new(params[:class])
      render :action=>'new'
    end
  end

  def update
    @class = OpenMedia::Schema::RDFS::Class.for(params[:id])
    begin
      if params[:deleted_property_uris]
        params[:deleted_property_uris].each do |dp|
          p = @class.properties.detect{|p| p.uri==dp}
          if p
            @class.properties.delete(p)
            p.destroy!
          end
        end
      end

      properties_params = params[:class].delete(:properties)
      @class.update!(params[:class].symbolize_keys)
      props_added = false
      if properties_params
        properties_params.each do |pp|
          pp[:range] = RDF::URI.new(pp[:range]) unless pp[:range].blank?
          if pp[:uri]
            property = OpenMedia::Schema::RDF::Property.for(pp[:uri])
            pp.delete(:url)
            property.update!(pp.symbolize_keys)  # update all attributes except uri
          else
            @class.properties << OpenMedia::Schema::RDF::Property.create_in_class!(@class, pp)
            props_added = true
          end
        end
      end
      @class.save! if props_added
      flash[:notice] = 'Class successfully updated,'
      redirect_to admin_schema_collection_class_path(rdf_id(@collection), rdf_id(@class))
    rescue Exception => e
      flash[:error] = e.to_s
      render :action=>'edit'
    end      
      
  end

  def edit
    @class = OpenMedia::Schema::RDFS::Class.for(params[:id])    
  end


  def destroy
    @class = OpenMedia::Schema::RDFS::Class.for(params[:id])    
    @class.destroy!    
    flash[:notice] = 'Class successfully deleted.'
    redirect_to admin_schema_collection_path(rdf_id(@collection))
  end

  def property_list
    #response = OpenMedia::Schema.get_class_definition(params[:class_uri])['properties'].collect{|p| { :label=>p['label'], :identifier=>p['identifier'] }
    #}.sort {|a,b| a[:label] <=> b[:label]}
    response = OpenMedia::Schema.get_class_definition(params[:class_uri])['properties'].collect{|p| p['identifier'] }.sort {|a,b| a <=> b}
    render :json=>response
  end



  
private
  def load_objects
    params[:collection_id] = params[:collection_id].gsub(/:/,'/') if params[:collection_id]
    @collection = OpenMedia::Schema::SKOS::Collection.for(params[:collection_id]) if params[:collection_id]    
  end

  def filter_empty_properties
    if params[:class] && params[:class][:properties]
      params[:class][:properties] = params[:class][:properties].reject{|p| p.values.all?{|v| v.blank?}}
    end
  end    
  

end
