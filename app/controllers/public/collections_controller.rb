class Public::CollectionsController < Public::BaseController
  
  def index
    @collections = current_site.skos_collection.sub_collections
  end

  def show
    @collection = OpenMedia::Schema::SKOS::Collection.for(params[:id])
    @classes = @collection.concepts.collect{|c| c.rdfs_class}
  end

end
