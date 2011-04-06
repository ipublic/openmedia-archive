class Public::SitesController < ApplicationController
  layout 'public'
  
  skip_before_filter :load_site
  
  def new
    @site = OpenMedia::Site.new(:openmedia_name=>'Our OpenMedia Site')
    @municipality = OpenMedia::NamedPlace.new
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

    @municipality = OpenMedia::InferenceRules::GeographicName.find_by_name_and_id(params[:municipality][:name], params[:municipality][:source_id].to_i)
    @site = OpenMedia::Site.new(params[:site].merge(:url=>site_url, :municipality=>@municipality))
    @name = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardName.new(params[:name])
    @email = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardEmail.new(params[:email])
    
    if @admin.valid? && @site.valid?
      @site.save!
      @site.initialize_metadata
      @admin.site=@site
      @admin.save!
      @vcard = OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgCoreVcardVcard.for(@site.vcards_rdf_uri/UUID.new.generate.gsub(/-/,''))
      @name.save!
      @vcard.n = @name
      @vcard.email = @email
      @email.save!
      @vcard.save!      
    else
      render :action=>:new
    end
    
  end

  def autocomplete_geoname
    places = OpenMedia::InferenceRules::GeographicName.find_by_name(params[:term])
    render :json=>places.collect{|np| {:id=>np.source_id, :label=>"#{np.name}, #{np.state_abbreviation}", :value=>"#{np.name}, #{np.state_abbreviation}"}}
  end

end
