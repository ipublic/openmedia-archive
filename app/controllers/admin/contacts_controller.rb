class Admin::ContactsController < Admin::BaseController

  def index
    @contacts = VCard::VCard.all
  end

  def show
    @contact = VCard::VCard.get(params[:id])
  end

  def new
    @contact = VCard::VCard.new
  end

  def new_email
    render :partial => 'email', :locals => {:email => VCard::Email.new }
  end

  def new_telephone
    render :partial => 'telephone', :locals => {:telephone => VCard::Telephone.new }
  end

  def new_address
    render :partial => 'address', :locals => {:address => VCard::Address.new }
  end

  def create
    @contact = VCard::VCard.new(params[:contact])

    if @contact.save
      flash[:notice] = 'Successfully created Contact.'
      redirect_to(admin_contact_path(@contact))
    else
      flash[:error] = 'Unable to create Contact.'
      render :action => "new"
    end
  end

  def edit
    @contact = VCard::VCard.get(params[:id])
#      @contact.telephone.length > 0 ? 
  end

  def update
    @contact = VCard::VCard.get(params[:id])
    @contact.attributes = params[:contact]

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Successfully updated Contact.'
        format.html { redirect_to(admin_contact_path) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error updating Contact."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /contact/:id
  def destroy
    @contact = VCard::VCard.get(params[:id])
    unless @contact.nil?
      @contact.destroy
      redirect_to(admin_contacts_url)
    else
      flash[:error] = "The Contact could not be found, refresh the Contact list and try again."
      redirect_to(admin_contacts_url)
    end
  end


  def autocomplete
    # startkey = params[:term].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'')
    # @uris = OpenMedia::Schema::VCard.prefix_search(startkey)
    # render :json=>@uris.collect{|u| {:id=>u.to_s, :label=>u.to_s, :value=>(u.fragment || u.path.split('/').last)} }    
  end

end
