class Admin::HomeController < ApplicationController
  before_filter :check_for_subdomain
  before_filter :authenticate_admin!

  def index
    @collections = om_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}
    if current_site
      @collections.concat(current_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}) unless current_site == om_site
    end
  end

  def show
    @collection = OpenMedia::Schema::SKOS::Collection.for(params[:id])
    if current_site
      @classes = @collection.concepts.collect {|c| c.rdfs_class}.select{|c| current_site.skos_collection.uri.parent==c.uri.parent.parent}
    else
      @classes = @collection.concepts.collect {|c| c.rdfs_class}
    end
  end

private
  def check_for_subdomain
    if request.subdomains.size == 0
      redirect_to root_path
    end
  end

  
end
