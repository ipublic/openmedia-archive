class Admin::HomeController < ApplicationController
  before_filter :authenticate_user!
  
end
