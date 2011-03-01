class Admin::VcardsController < ApplicationController

  before_filter :load_vcard
  #before_filter :convert_params, :only => [:create, :update]

  def index
    @vcards = vcard_model.each.to_a
  end

  def new
    @vcard = vcard_model.new
  end

  def create
    name_params = params[:vcard][:n]
    org_params = params[:vcard][:org]
    email_params = params[:vcard][:email]
    tel_params = params[:vcard][:tel]        
    adr_params = params[:vcard][:adr]    
    @vcard = vcard_model.for(RDF::URI.new('http://data.civicopenmedia.org')/OpenMedia::Site.instance.identifier/"#{UUID.new.generate.gsub(/-/,'')}",params[:vcard])
    @vcard.n = name_model.new(name_params).save! if name_params
    @vcard.org = org_model.new(org_params).save! if org_params
    @vcard.email = email_model.new(email_params).save! if email_params
    @vcard.tel = tel_model.new(tel_params).save! if tel_params            
    @vcard.adr = adr_model.new(adr_params).save! if adr_params
    if @vcard.save!
      redirect_to admin_vcard_path(rdf_id(@vcard))
    else
      render :action=>:new
    end
  end

  def update
    name_params = params[:vcard][:n]
    org_params = params[:vcard][:org]
    email_params = params[:vcard][:email]
    tel_params = params[:vcard][:tel]        
    adr_params = params[:vcard][:adr]
    begin
      if name_params
        if @vcard.n
          @vcard.n.update!(name_params.to_hash.symbolize_keys!)
        else
          @vcard.n = name_model.new(name_params).save!
        end
      end

      if org_params
        if @vcard.org
          @vcard.org.update!(org_params.to_hash.symbolize_keys!)
        else
          @vcard.org = org_model.new(org_params).save!
        end
      end

      if email_params
        if @vcard.email
          @vcard.email.update!(email_params.to_hash.symbolize_keys!)
        else
          @vcard.email = email_model.new(email_params).save!
        end
      end

      if tel_params
        if @vcard.tel
          @vcard.tel.update!(tel_params.to_hash.symbolize_keys!)
        else
          @vcard.tel = tel_model.new(tel_params).save! if tel_params
        end
      end

      if adr_params
        if @vcard.adr
          @vcard.adr.update!(adr_params.to_hash.symbolize_keys!)
        else        
          @vcard.adr = adr_model.new(adr_params).save!
        end
      end

      @vcard.update!(params[:vcard])
      redirect_to admin_vcard_path(rdf_id(@vcard))
    rescue => e
      render :action=>:edit
    end

  end

  def autocomplete
    startkey = params[:term].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'')
    @uris = OpenMedia::Schema::VCard.prefix_search(startkey)
    render :json=>@uris.collect{|u| {:id=>u.to_s, :label=>u.to_s, :value=>(u.fragment || u.path.split('/').last)} }    
  end
  

private
  def vcard_model
    vcard = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource
    vcard.default_source(OpenMedia::Site.instance.metadata_repository)
    vcard
  end

  def name_model
    name = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Name).spira_resource
    name.default_source(OpenMedia::Site.instance.metadata_repository)
    name
  end

  def org_model
    org = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Organization).spira_resource
    org.default_source(OpenMedia::Site.instance.metadata_repository)
    org
  end

  def email_model
    email = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Email).spira_resource
    email.default_source(OpenMedia::Site.instance.metadata_repository)
    email
  end

  def tel_model
    tel = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Tel).spira_resource
    tel.default_source(OpenMedia::Site.instance.metadata_repository)
    tel
  end

  def adr_model
    adr = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Address).spira_resource
    adr.default_source(OpenMedia::Site.instance.metadata_repository)
    adr
  end

  # def convert_params    
  #   convert_hash(params[:vcard])
  # end
  # 
  # def convert_hash(h)
  #   h.each do |k,v|
  #     if v.is_a?(String) && v.blank?
  #       h.delete(k)
  #     elsif v.is_a?(Hash)
  #       convert_hash(v)
  #       if v.size==0 || (v.size==1 && v.keys.first=='type') || (v.size==2 && v.keys.sort == %w(country_name type))
  #         h.delete(k)
  #       end
  #     end
  #   end
  # end

  def load_vcard
    @vcard = vcard_model.for(params[:id]) if params[:id]
  end  

end
