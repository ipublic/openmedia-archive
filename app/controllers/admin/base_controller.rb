class Admin::BaseController < ApplicationController
  before_filter :check_for_subdomain
  before_filter :authenticate_admin!    

private
  def check_for_subdomain
    if request.subdomains.size == 0
      redirect_to root_path
    elsif current_admin && (current_admin.site.identifier != request.subdomains.first)
      redirect_to "#{current_admin.site.url}/admin"
    end
  end
  
end
