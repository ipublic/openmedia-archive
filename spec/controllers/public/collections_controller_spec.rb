require 'spec_helper'

describe Public::CollectionsController do
  render_views

  context 'main (non-subdomain) site' do
    it 'should show collections from om on main page' do
      get :index
      response.should be_success
      response.should render_template('index')
      assigns[:collections].size.should == om_site.skos_collection.sub_collections.count
    end

    it 'should show classes within a collection' do
      @collection = om_site.skos_collection.sub_collections.first
      @om_class = create_test_rdfs_class(:site=>om_site, :collection=>@collection)      
      get :show, :id=>spec_rdf_id(@collection)
      response.should be_success
      assigns[:collection].should_not be_nil
      assigns[:classes].should == [@om_class]
      response.should render_template('show')
    end
  end

  context 'hosted site (accessed with subdomain)' do
    before(:each) do
      @site = create_test_site(:admin=>@admin, :identifier=>'whoville')

      @admin = create_test_admin(@site)      
      @collection = create_test_collection(:site=>@site)
      @request.host = "whoville.#{OM_DOMAIN}"
    end

    it 'should show om collections plus local ones on index' do
      get :index
      response.should be_success
      assigns[:collections].size.should == om_site.skos_collection.sub_collections.count + 1
      response.should render_template('index')
    end

    it 'should only show local site classes in om collection' do
      collection = om_site.skos_collection.sub_collections.first
      @local_class = create_test_rdfs_class(:site=>@site, :collection=>collection)
      @om_class = create_test_rdfs_class(:site=>om_site, :collection=>collection)
      
      get :show, :id=>spec_rdf_id(collection)
      response.should be_success
      assigns[:classes].size.should == 1
      assigns[:classes].first.should == @local_class
      response.should render_template('show')
    end
    
  end
end
