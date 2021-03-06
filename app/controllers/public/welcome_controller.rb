class Public::WelcomeController < ApplicationController
  layout 'public'
  include GoogleMapsHelper

  def index
    @site = current_site
    @site = om_site if @site.nil?
    
    ns = OmLinkedData::Namespace.new @site.url
    @collections = ::OmLinkedData::Collection.by_base_uri(:key => ns.base_uri)
    
    # @collections = om_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}
    if current_site
      # @collections.concat(current_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}) unless current_site == om_site

      dash_id = current_site.default_dashboard
      if dash_id.blank?
        @dashboard = OpenMedia::Dashboard.first
      else
        @dashboard = OpenMedia::Dashboard.get dash_id
      end

      # Load GoogleMaps
      initialize_gmap
    end
  end

  def license
    # @site = current_site
    # @site = om_site if @site.nil?
    @site = om_site
  end

end
