require 'spec_helper'

describe Schema::CollectionsController do
  render_views

  before(:all) do
    reset_test_db!
    @site = create_test_site
    top_collection = @site.skos_collection
    1.upto(2) do |i|
      c = OpenMedia::Schema::SKOS::Collection.create_in_collection!(@site.skos_collection, :label=>"Collection #{i}")
      top_collection.members << c.uri
      top_collection.save!
    end
  end

  it 'should show list of collections for current site' do
    get :index
    response.should be_success
    response.should render_template('index')
    assigns[:collections].size.should == 2
  end

  it 'should have page to create new collection' do
    get :new
    assigns[:collection].should_not be_nil            
    response.should be_success
    response.should render_template('new')
  end

  it 'should allow new collections to be created' do
    lambda { post :create, :collection=>{ :label=> 'New Collection', :hidden=>false } }.should change(OpenMedia::Schema::SKOS::Collection, :count).by(1)
    @site.skos_collection.sub_collections.size.should == 3
    response.should redirect_to(schema_collections_path)
  end

  it 'should show validation errors when creating collection' do
    post :create, :collection=>{ :label=> '', :hidden=>false }
    response.should be_success
    response.should render_template('new')
  end

  describe 'for an existing collection' do
    before(:all) do
      @collection = OpenMedia::Schema::SKOS::Collection.create_in_collection!(@site.skos_collection, :label=>"Test Collection")    
    end
    
    it 'should have page to show collection' do
      get :show, :id=>spec_rdf_id(@collection, true)
      assigns[:collection].should_not be_nil                  
      response.should be_success
      response.should render_template('show')
    end

    it 'should have page to edit collection' do
      get :edit, :id=>spec_rdf_id(@collection, true)
      assigns[:collection].should_not be_nil            
      response.should be_success
      response.should render_template('edit')
    end
    
    it 'should allow collection to be updated' do     
      put :update, :id=>spec_rdf_id(@collection, true), :collection=>{ 'label'=> 'New Label', 'hidden'=>false }
      response.should redirect_to(schema_collections_path)
      @collection.reload
      @collection.label.should == 'New Label'
    end

    it 'should allow collections to be deleted' do
      lambda { delete :destroy, :id=>spec_rdf_id(@collection, true) }.should change(OpenMedia::Schema::SKOS::Collection, :count).by(-1)
      assigns[:collection].should_not be_nil
      response.should redirect_to(schema_collections_path)
    end
  end
   
end
