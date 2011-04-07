class Public::CollectionsController < Public::BaseController
  
  def index
    @collections = ipublic_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}
    @collections.concat(current_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label})
  end

  def show
    @collection = OpenMedia::Schema::SKOS::Collection.for(params[:id])
    @classes = @collection.concepts.collect{|c| c.rdfs_class}
  end

end
