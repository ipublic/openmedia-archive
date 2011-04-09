class Public::CollectionsController < Public::BaseController
  
  def index
    @collections = ipublic_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}
    if current_site
      @collections.concat(current_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}) unless current_site == ipublic_site
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
