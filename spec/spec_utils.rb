# These used to be in spec_helper, they were moved here so Spork can require them on each run
def om_site
  OpenMedia::Site.find_by_identifier('om')
end

def create_test_site(data={})
  @test_site = OpenMedia::Site.create!({:identifier=>'testgov', :url=>'http://test.gov',
                                         :municipality=>OpenMedia::NamedPlace.new(:name=>'My City')}.merge(data))
  COUCHDB_SERVER.database!("#{@test_site.identifier}_metadata").recreate!
  @test_site
end

def create_test_admin(site)
  Admin.create!(:email=>'test@ipublic.org', :password=>'ChangeMe',
                    :password_confirmation=>'ChangeMe', :site=>site, :confirmed_at=>Time.now)
end


def create_test_collection(data={})
  # site = data.delete(:site) || create_test_site
  # @test_collection = OpenMedia::Schema::SKOS::Collection.create_in_collection!(site.skos_collection, {:label=>'Test Collection'}.merge(data))
  # @test_collection
end


def create_test_rdfs_class(data={})
  # properties = data.delete(:properties)
  # collection = data.delete(:collection) || create_test_collection
  # site = data.delete(:site) || create_test_site
  # c = OpenMedia::Schema::RDFS::Class.create_in_site!(site, {:label=>'Reported Crimes', :comment=>'crime reports, etc'}.merge(data))
  # if properties
  #   for p in properties
  #     c.properties << OpenMedia::Schema::RDF::Property.create_in_class!(c, p.merge(:domain=>c))
  #   end
  #   c.save!
  # end
  # collection.members << c.uri
  # collection.save!
  # c
end

def create_test_owl_class(data={})
  # object_properties = data.delete(:object_properties)
  # site = data.delete(:site) || create_test_site
  # c = OpenMedia::Schema::OWL::Class.create_in_site!(site, {:label=>'Reported Crimes', :comment=>'crime reports, etc'}.merge(data))
  # if object_properties
  #   for p in object_properties
  #     c.object_properties << OpenMedia::Schema::OWL::ObjectProperty.create_in_class!(c, p)
  #   end
  #   c.save!
  # end
  # c
end


# def create_test_catalog(data={})
#   OpenMedia::Catalog.create!({:title=>'Test Catalog', :metadata=>{ }}.merge(data))
# end

# def create_test_datasource(data={})
#   ds = OpenMedia::Datasource.create!({:title=>'Test Dataset',
#                                        :source_type=>OpenMedia::Datasource::TEXTFILE_TYPE,
#                                        :parser=>OpenMedia::Datasource::DELIMITED_PARSER}.merge(data))
# 
# end
# 
# def test_csv_path
#   File.join(Rails.root, 'spec', 'testdata', 'test.csv')
# end
# 
# def test_shapefile_path
#   File.join(Rails.root, 'spec', 'testdata', 'AirSpacePly.zip')
# end
# 
# 
# def spec_rdf_id(resource)
#   if resource.respond_to?(:uri)
#     spec_rdf_id(resource.uri)
#   elsif resource.instance_of?(RDF::URI)
#     resource.path[1..-1].gsub(/\//,':')
#   else
#     raise "Could not convert #{resource.inspect} to an RDF::URI"
#   end
# end

shared_examples_for "an admin controller" do |action, params|
  action ||= :index
  params ||= { }

  it "should redirect to public page when not accessing via subdomain" do
    get action, params
    response.should redirect_to(root_path)
  end

  context 'when access with subdomain url' do
    before(:each) do
      @site = create_test_site
      @request.host = "#{@site.identifier}.#{OM_DOMAIN}"
    end
  
    it "should redirect to admin login page when not logged in as an admin" do
      get action, params
      response.should redirect_to(new_admin_session_path)
    end

    it "should allow access when logged in as an admin" do
      @admin = create_test_admin(@site)      
      sign_in :admin, @admin
      get action, params
      response.should be_success
    end
  end
end
