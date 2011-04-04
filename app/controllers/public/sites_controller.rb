class Public::SitesController < ApplicationController
  layout 'public'
  
  skip_before_filter :load_site
  
  def new
    @site = OpenMedia::Site.new(:openmedia_name=>'Our OpenMedia Site')
    @admin = Admin.new
    @vcard = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.new
    @name = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardName.new
    @email = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardEmail.new
  end

  def create
    @admin = Admin.new(:email=>params[:email][:value], :password=>params[:admin][:password],
                     :password_confirmation=>params[:admin][:password_confirmation])
    subdomain = params[:site].delete(:subdomain)
    site_url = "http://#{subdomain}.#{DOMAIN}"
    if (request.port != 80)
      site_url = "#{site_url}:#{request.port}"
    end

    @site = OpenMedia::Site.new(params[:site].merge(:url=>site_url))
    @name = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardName.new(params[:name])
    @email = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardEmail.new(params[:email])
    
    if @admin.valid? && @site.valid?
      @site.save!
      @admin.site_id=@site.id
      @admin.save!
      @vcard = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(@site.vcards_rdf_uri/UUID.new.generate.gsub(/-/,''))
      @vcard.n = @name
      @vcard.email = @email
      @vcard.save!      
    else
      render :action=>:new
    end
    
  end

end
