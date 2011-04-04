class Public::BaseController < ApplicationController
  layout 'site'

  before_filter :load_site

  private
  def load_site
    if request.subdomains.count == 0
      redirect_to home_path
    end
  end  
end
