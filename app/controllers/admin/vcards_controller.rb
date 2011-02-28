class Admin::VcardsController < ApplicationController

  before_filter :compact_params, :only => [:create, :update]

  def index
    @vcards = vcard_model.each.to_a
  end

  def show
    @vcard = vcard_model.for(params[:id])
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
      redirect_to admin_vcards_path
    else
      render :action=>:new
    end
  end

  def edit
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

  def compact_params    
    compact_hash(params[:vcard])
  end

  def compact_hash(h)
    h.each do |k,v|
      puts "compacting #{v.class}: #{v.inspect}"
      if v.is_a?(String) && v.blank?
        h.delete(k)
      elsif v.is_a?(Hash)
        compact_hash(v)
        if v.size==0 || (v.size==1 && v.keys.first=='type') || (v.size==2 && v.keys.sort == %w(country_name type))
          h.delete(k)
        end
      end
      puts "after compacting: #{h.inspect}"
    end    
  end



end
