class Admin::VcardsController < ApplicationController
  before_filter :authenticate_admin!
  before_filter :setup_vcard
  before_filter :load_vcard
  #before_filter :convert_params, :only => [:create, :update]

  def index
    @vcards = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.each.to_a
  end

  def new
    @vcard = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.new
  end

  def create
    name_params = params[:vcard][:n]
    org_params = params[:vcard][:org]
    email_params = params[:vcard][:email]
    tel_params = params[:vcard][:tel]        
    adr_params = params[:vcard][:adr]    
    @vcard = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(current_site.vcards_rdf_uri/UUID.new.generate.gsub(/-/,''), params[:vcard])
    @vcard.n = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardName.new(name_params).save! if name_params
    @vcard.org = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardOrganization.new(org_params).save! if org_params
    @vcard.email = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardEmail.new(email_params).save! if email_params
    @vcard.tel = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardTel.new(tel_params).save! if tel_params            
    @vcard.adr = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardAddress.new(adr_params).save! if adr_params
    if @vcard.save!
      redirect_to admin_vcard_path(rdf_id(@vcard))
    else
      render :action=>:new
    end
  end

  def update
    name_params = params[:vcard].delete(:n)
    org_params = params[:vcard].delete(:org)
    email_params = params[:vcard].delete(:email)
    tel_params = params[:vcard].delete(:tel)
    adr_params = params[:vcard].delete(:adr)
    begin
      if name_params
        if @vcard.n
          @vcard.n.update!(name_params.to_hash.symbolize_keys!)
        else
          @vcard.n = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardName.new(name_params).save!
        end
      end

      if org_params
        if @vcard.org
          @vcard.org.update!(org_params.to_hash.symbolize_keys!)
        else
          @vcard.org = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardOrganization.new(org_params).save!
        end
      end

      if email_params
        if @vcard.email
          @vcard.email.update!(email_params.to_hash.symbolize_keys!)
        else
          @vcard.email = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardEmail.new(email_params).save!
        end
      end

      if tel_params
        if @vcard.tel
          @vcard.tel.update!(tel_params.to_hash.symbolize_keys!)
        else
          @vcard.tel = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardTel.new(tel_params).save! if tel_params
        end
      end

      if adr_params
        if @vcard.adr
          @vcard.adr.update!(adr_params.to_hash.symbolize_keys!)
        else        
          @vcard.adr = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardAddress.new(adr_params).save!
        end
      end

      @vcard.update!(params[:vcard].to_hash.symbolize_keys!)
      redirect_to admin_vcard_path(rdf_id(@vcard))
    rescue => e
      render :action=>:edit
    end

  end

  def destroy
    # @vcard.n.destroy! if @vcard.n
    # @vcard.org.destroy! if @vcard.org 
    # @vcard.email.destroy! if @vcard.email
    # @vcard.tel.destroy! if @vcard.tel
    # @vcard.adr.destroy! if @vcard.adr
    # @vcard.destroy!
    redirect_to admin_vcards_path
  end


  def autocomplete
    startkey = params[:term].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'')
    @uris = OpenMedia::Schema::VCard.prefix_search(startkey)
    render :json=>@uris.collect{|u| {:id=>u.to_s, :label=>u.to_s, :value=>(u.fragment || u.path.split('/').last)} }    
  end
  

private

  def setup_vcard
    current_site.initialize_metadata
  end

  def load_vcard
    @vcard = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(params[:id]) if params[:id]
  end
    

end
