class Public::HomeController < Public::BaseController

  layout 'public'
  
  skip_before_filter :load_site

end
