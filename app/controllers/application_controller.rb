class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :current_site, :rdf_id

  rescue_from OpenMedia::NoSiteDefined, :with=> :no_site_defined

  SITE_NOT_DEFINED_ERROR_MSG = "You must first setup your site"

  def current_user
    nil
  end

  def current_site
    OpenMedia::Site.instance
  end

  def rdf_id(resource)
    if resource.respond_to?(:uri)
      rdf_id(resource.uri)
    elsif resource.instance_of?(RDF::URI)
      CGI.escape(resource.path[1..-1])
    else
      raise "Could not convert #{resource.inspect} to an RDF::URI"
    end
  end
  
  

private  
  def no_site_defined
    flash[:error] = SITE_NOT_DEFINED_ERROR_MSG
    redirect_to new_admin_site_path
  end

end
