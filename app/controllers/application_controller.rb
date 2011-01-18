class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :current_site

  rescue_from OpenMedia::NoSiteDefined, :with=> :no_site_defined

  SITE_NOT_DEFINED_ERROR_MSG = "You must first setup your site"

  def current_user
    nil
  end

  def current_site
    OpenMedia::Site.instance
  end

private  
  def no_site_defined
    flash[:error] = SITE_NOT_DEFINED_ERROR_MSG
    redirect_to new_admin_site_path
  end

end
