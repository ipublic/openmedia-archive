class Admin::LinkedData::CollectionsController < Admin::BaseController

    before_filter :convert_hidden, :only=>[:update, :create]

    def index
      ns = ::LinkedData::Namespace.new current_site.url
      @collections = ::LinkedData::Collection.by_base_uri(:key => ns.base_uri)
    end

    def new
      @collection = ::LinkedData::Collection.new
    end

    def create
      @new_collection = params[:collection]
      @new_collection["tags"] = @new_collection["tags"].split(',')
      @new_collection["base_uri"] = current_site.url
      @collection = ::LinkedData::Collection.new(@new_collection)
      
      if @collection.save
        flash[:notice] = 'Collection successfully created.'
        redirect_to admin_om_linked_data_collection_path(@collection)
      else
       flash[:error] = 'Unable to create Collection.'
       render :action => "new"
      end
    end

    def show
      @collection = ::LinkedData::Collection.find(params[:id])
      @sorted_vocabs = ::LinkedData::Vocabulary.sort_by_authority
      
      site_ns = ::LinkedData::Namespace.new current_site.url
      om_ns = ::LinkedData::Namespace.new om_site.url
      
      @site_vocabs = @sorted_vocabs.delete(site_ns.authority) { |val| val = [] }
      @commons_vocabs = @sorted_vocabs.delete(om_ns.authority) { |val| val = [] }
      @other_vocabs = @sorted_vocabs
    end

    def edit
      @collection = ::LinkedData::Collection.find(params[:id])
      @collection["tags"] = @collection["tags"].join(',')
    end

    def update
      @collection = ::LinkedData::Collection.find(params[:id])
      @update_collection = params[:collection]
      @update_collection["tags"] = @update_collection["tags"].split(',')
      @collection.attributes = @update_collection
      
      if @collection.save
        flash[:notice] = 'Collection successfully updated.'
        redirect_to admin_om_linked_data_collection_path(@collection)
#        redirect_to admin_om_linked_data_collection_path(rdf_id(@collection.uri))
      else
       flash[:error] = 'Unable to update Collection.'
       render :action => "edit"
#        redirect_to edit_admin_om_linked_data_collection_path(@collection.id)
      end
    end

    def destroy
      @collection = ::LinkedData::Collection.find(params[:id])

      # TODO - Deleting collection will require support for deleting Vocabs and Properties
      
      flash[:notice] = 'Unable to delete Collection.'
      redirect_to admin_om_linked_data_collections_path
    end

private
  def convert_hidden
    params[:collection][:hidden] = (params[:collection][:hidden] && params[:collection][:hidden] == '1') ? true : false
  end


  end
