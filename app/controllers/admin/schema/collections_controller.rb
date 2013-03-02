class Admin::Schema::CollectionsController < Admin::BaseController

  before_filter :load_collection
  before_filter :convert_hidden, :only=>[:update, :create]

  def index
    @collections = om_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}
    @collections.concat(current_site.skos_collection.sub_collections.sort{|c1,c2| c1.label <=> c2.label}) unless current_site = om_site
  end

  def new
    @collection = OpenMedia::Schema::SKOS::Collection.new
  end

  def show
    @collection = ::OmLinkedData::Collection.get(params[:id])
    
    @collection = OpenMedia::Schema::SKOS::Collection.for(params[:id])
    @classes = @collection.concepts.collect {|c| c.rdfs_class}.select{|c| current_site.skos_collection.uri.parent==c.uri.parent.parent}
  end

  def create
    @collection = OpenMedia::Schema::SKOS::Collection.create_in_collection!(current_site.skos_collection, params[:collection])
    if @collection.errors.count == 0
      flash[:notice] = 'Collection successfully created.'
      redirect_to admin_schema_collection_path(rdf_id(@collection.uri))
    else
      render 'new'
    end
  end

  def update
    @collection.update!(params[:collection].symbolize_keys)
    flash[:notice] = 'Collection successfully updated.'
    redirect_to admin_schema_collection_path(rdf_id(@collection.uri))
  end

  def destroy
    current_site.skos_collection.delete_member!(@collection.uri)
    @collection.destroy!    
    flash[:notice] = 'Collection successfully deleted.'
    redirect_to admin_schema_collections_path
  end
  
private
  def load_collection
    @collection = OpenMedia::Schema::SKOS::Collection.for(params[:id]) if params[:id]
  end

  def convert_hidden
    params[:collection][:hidden] = (params[:collection][:hidden] && params[:collection][:hidden] == '1') ? true : false
  end


end
