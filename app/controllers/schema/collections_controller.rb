class Schema::CollectionsController < ApplicationController

  before_filter :load_collection
  before_filter :convert_hidden, :only=>[:update, :create]

  def index
    @collections = OpenMedia::Site.instance.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}
  end

  def new
    @collection = OpenMedia::Schema::SKOS::Collection.new
  end

  def show
    @collection = OpenMedia::Schema::SKOS::Collection.for(params[:id])
    @classes = @collection.concepts.collect {|c| c.rdfs_class}
  end

  def create
    @site = OpenMedia::Site.instance
    @collection = OpenMedia::Schema::SKOS::Collection.create_in_collection!(@site.skos_collection, params[:collection])
    if @collection.errors.count == 0
      flash[:notice] = 'Collection successfully created.'
      redirect_to schema_collections_path
    else
      render 'new'
    end
  end

  def update
    @collection.update!(params[:collection].symbolize_keys)
    flash[:notice] = 'Collection successfully updated.'
    redirect_to schema_collections_path
  end

  def destroy
    OpenMedia::Site.instance.skos_collection.delete_member!(@collection.uri)
    @collection.destroy!    
    flash[:notice] = 'Collection successfully deleted.'
    redirect_to schema_collections_path
  end
  
private
  def load_collection
    @collection = OpenMedia::Schema::SKOS::Collection.for(params[:id]) if params[:id]
  end

  def convert_hidden
    params[:collection][:hidden] = (params[:collection][:hidden] && params[:collection][:hidden] == '1') ? true : false
  end


end
