class Schema::ClassesController < ApplicationController

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

  def new_property
    @property = OpenMedia::Schema::RDF::Property.new
    render :partial=>'property', :locals=>{:base_name=>'class[properties][]', :property=>@property}, :layout=>nil
  end

  def create
    begin
      properties_params = params[:class].delete(:properties)
      @class = OpenMedia::Schema::RDFS::Class.create_in_site!(OpenMedia::Site.instance, params[:class])
      @collection.members << @class.uri
      @collection.save!
      properties_params.each do |pp|
        pp[:range] = RDF::URI.new(pp[:range]) unless pp[:range].blank?
        @class.properties << OpenMedia::Schema::RDF::Property.create_in_class!(@class, pp)
      end
      @class.save!

      redirect_to schema_collection_path(rdf_id(@collection))
    rescue Exception => e
      flash[:error] = e.to_s
      @class = OpenMedia::Schema::RDFS::Class.new(params[:class])
      render :action=>'new'
    end
  end

  def update
    begin
      if params[:deleted_property_uris]
        params[:deleted_property_uris].each do |dp|
          p = @class.properties.detect{|p| p.uri==dp}
          if p
            @class.properties.delete(p)
            p.destroy!
            puts "deleted #{dp}"
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
      redirect_to schema_collection_class_path(rdf_id(@collection), rdf_id(@class))
    rescue Exception => e
      flash[:error] = e.to_s
      render :action=>'edit'
    end      
      
  end

  
private
  def load_objects
    @class = OpenMedia::Schema::RDFS::Class.for(CGI.unescape(params[:id])) if params[:id]
    @collection = OpenMedia::Schema::SKOS::Collection.for(CGI.unescape(params[:collection_id])) if params[:collection_id]    
  end

  def filter_empty_properties
    if params[:class] && params[:class][:properties]
      params[:class][:properties] = params[:class][:properties].reject{|p| p.values.all?{|v| v.blank?}}
    end
  end    
  

end
