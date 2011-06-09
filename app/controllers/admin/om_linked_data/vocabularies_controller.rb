class Admin::OmLinkedData::VocabulariesController < Admin::BaseController

  def autocomplete
    # startkey = params[:term].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'')
    # @uris = OpenMedia::OmLinkedData::RDFS::Class.prefix_search(startkey)
    # render :json=>@uris.collect{|u| {:id=>u.to_s, :label=>u.to_s, :value=>(u.fragment || u.path.split('/').last)} }    
  end

  def index
    @vocabularies = ::OmLinkedData::Vocabulary.all
  end

  def new
    @collection = ::OmLinkedData::Collection.get(params[:collection_id])
    @vocabulary = ::OmLinkedData::Vocabulary.new
  end

  def new_property
    @property = ::OmLinkedData::Property.new
    render :partial=>'property', :locals=>{:base_name=>'class[properties][]', :property=>@property}, :layout=>nil
  end

  def show
    @collection = ::OmLinkedData::Collection.get(params[:collection_id])
    @vocabulary = ::OmLinkedData::Vocabulary.get(params[:id])
  end

  def create
    @collection = ::OmLinkedData::Collection.get(params[:collection_id])
    
    @new_vocabulary = params[:vocabulary]
    @new_vocabulary["tags"] = @new_vocabulary["tags"].split(',')
    @new_vocabulary["base_uri"] = current_site.url
    @new_vocabulary["collection"] = @collection
    @vocabulary = ::OmLinkedData::Vocabulary.new(@new_vocabulary)
    
    if @vocabulary.save
      flash[:notice] = 'Vocabulary successfully created.'
      redirect_to admin_om_linked_data_collection_vocabulary_path(@collection, @vocabulary)
    else
     flash[:error] = 'Unable to create Vocabulary.'
     render :action => "new"
    end
  end
  
  def edit
    @collection = ::OmLinkedData::Collection.get(params[:collection_id])
    @vocabulary = ::OmLinkedData::Vocabulary.get(params[:id])
    @vocabulary["tags"] = @vocabulary["tags"].join(',')
  end

  def update
    @collection = ::OmLinkedData::Collection.get(params[:collection_id])
    @vocabulary = ::OmLinkedData::Vocabulary.find(params[:id])
    @update_vocabulary = params[:vocabulary]
    @update_vocabulary["tags"] = @update_vocabulary["tags"].split(',')
    @vocabulary.attributes = @update_vocabulary

    if @vocabulary.save
      flash[:notice] = 'Vocabulary successfully updated.'
      redirect_to admin_om_linked_data_collection_vocabulary_path(@collection, @vocabulary)
    else
     flash[:error] = 'Unable to update Vocabulary.'
     render :action => "edit"
    end
    
  end

  def destroy
  end

end
