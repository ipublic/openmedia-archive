require 'spec_helper'

describe Admin::VcardsController do
  render_views
  
  before(:all) do
    reset_test_db!
    seed_test_db!
  end

  describe 'before Site is setup' do
    it 'should redirect to Site form' do
      get :index
      response.should redirect_to(new_admin_site_path)
    end
  end

  describe 'once Site is setup' do
    before(:all) do
      @site = create_test_site
      @vcard_model = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource
      @name_model = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Name).spira_resource        
      1.upto(2) do |i|
        name = @name_model.new(:given_name=>"Person #{i}", :family_name=>"Person #{i}").save!
        @vcard_model.for("#{@site.identifier}/vcard-#{i}", :n=>name).save!
      end
    end

    it 'should have page listing vcards' do
      get :index
      response.should be_success
      assigns[:vcards].size.should == 2
      response.should render_template('index')    
    end

    it 'should have form for creating new vcards' do
      get :new
      response.should be_success
      response.should render_template('new')    
    end
  end
end
