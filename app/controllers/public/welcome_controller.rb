class Public::WelcomeController < ApplicationController
  layout 'public'

  def index
    # Determine which OM Site
    @site = OpenMedia::Site.first
    @site_banner = @site.welcome_message
  end

  def license
  end

end
