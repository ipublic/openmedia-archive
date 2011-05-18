class Public::DashboardsController < ApplicationController
  layout 'public'
  
  def index
    
  end

  def show
    @dash = OpenMedia::Dashboard.first
  end

end
