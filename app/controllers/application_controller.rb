class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_site, :om_site, :rdf_id
  before_filter :decode_rdf_id
  before_filter :load_site
  
  rescue_from OpenMedia::NoSiteDefined, :with=> :no_site_defined

  SITE_NOT_DEFINED_ERROR_MSG = "You must first setup your site"

  def current_site
    @current_site
  end

  def om_site
    @om_site
  end


  def rdf_id(resource)
    if resource.respond_to?(:uri)
      rdf_id(resource.uri)
    elsif resource.instance_of?(RDF::URI)
      resource.path[1..-1].gsub(/\//,':')
    else
      raise "Could not convert #{resource.inspect} to an RDF::URI"
    end
  end

private  
  def no_site_defined
    flash[:error] = SITE_NOT_DEFINED_ERROR_MSG
    session[:after_site_created] = params
    redirect_to new_admin_site_path
  end

  def decode_rdf_id
    params[:id] = params[:id].gsub(/:/,'/') if params[:id]
  end

  def load_site
    @om_site = OpenMedia::Site.find_by_identifier('om')
    if request.subdomains.count == 0
      @current_site = nil
    else
      @current_site = OpenMedia::Site.find_by_identifier(request.subdomains.first)
      if @current_site
        @current_site.initialize_metadata
      else
        redirect_to url_for(params.merge(:host=>"#{DOMAIN}:#{request.port}"))
      end
    end
  end    
  
end
