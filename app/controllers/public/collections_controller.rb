class Public::CollectionsController < ApplicationController
  layout 'public'
  
  def index
    @collections = OpenMedia::Site.instance.skos_collection.sub_collections
  end

  def show
    @collection = OpenMedia::Schema::SKOS::Collection.for(params[:id])
    @classes = @collection.concepts.collect{|c| c.rdfs_class}
  end

end
