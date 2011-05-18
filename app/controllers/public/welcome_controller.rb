class Public::WelcomeController < ApplicationController
  layout 'public'
  include GoogleMapsHelper

  def index
    @site = current_site
    @site = om_site if @site.nil?

    @collections = om_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}
    if current_site
      @collections.concat(current_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}) unless current_site == om_site

      # Load GoogleMaps
      initialize_gmap
    end
  end

  def license
  end

end
