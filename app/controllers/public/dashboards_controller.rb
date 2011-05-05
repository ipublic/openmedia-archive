class Public::DashboardsController < ApplicationController
  def index
    
  end

  def show
    @dash = OpenMedia::Dashboard.first
  end

end
