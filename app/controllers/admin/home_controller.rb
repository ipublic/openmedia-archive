class Admin::HomeController < Admin::BaseController

  def index
    dash_id = current_site.default_dashboard
    if dash_id.blank?
      @dashboard = OpenMedia::Dashboard.first
    else
      @dashboard = OpenMedia::Dashboard.get dash_id
    end
    
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
  
end
