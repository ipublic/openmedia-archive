require 'spec_helper'

describe Schema::ClassesController do

  before(:all) do
    reset_test_db!
    seed_test_db!    
    @site = create_test_site
    @collection = OpenMedia::Schema::SKOS::Collection.create_in_collection!(@site.skos_collection, :label=>"Test Collection")    
    @class = OpenMedia::Schema::RDFS::Class.create_in_site!(@site, :label=>'Date Test', :comment=>'Original Comment')
  end

  it 'should have form to create new classes' do
    get :new, :collection_id=>spec_rdf_id(@collection)
    response.should be_success    
    response.should render_template('new')
    assigns[:class].should be_instance_of(OpenMedia::Schema::RDFS::Class)
  end

  it 'should allow new properties to be added' do
    get :new_property
    response.should be_success
    response.should render_template('property')
  end

  it 'should allow new classes to be created' do
    post :create, :collection_id=>spec_rdf_id(@collection),
         :class=>{ :label=> 'New Class', :comment=>'The New Class is Neat',
                   :properties=>[{:label=>'myprop', :range=>RDF::XSD.string}]}
    response.should redirect_to(schema_collection_path(:id=>spec_rdf_id(@collection, true)))
    assigns[:class].properties.size.should == 1
    assigns[:class].properties.to_a[0].should exist
    assigns[:class].properties.to_a[0].range.should == RDF::XSD.string
  end

  it 'should reject classes with duplicate labels' do
    post :create, :collection_id=>spec_rdf_id(@collection), :class=>{ :label=> 'New Class' }
    response.should be_success
    response.should render_template('new')
  end
  
  it 'should provide json autocompletion for class and datatype names' do    
    get :autocomplete, :term=>'date'
    response.should be_success
    json = JSON.parse(response.body)
    json.size.should == 3
  end

  it 'should show existing classes' do
    get :show, :id=>spec_rdf_id(@class, true), :collection_id=>spec_rdf_id(@collection)
    response.should be_success
    response.should render_template('show')
  end

  it 'should allow existing classes to be edited' do
    get :edit, :id=>spec_rdf_id(@class, true), :collection_id=>spec_rdf_id(@collection)
    response.should be_success
    response.should render_template('edit')
  end

  it 'should allow existing classes to be updated' do
    put :update, :id=>spec_rdf_id(@class, true), :collection_id=>spec_rdf_id(@collection),
                 :class=>{ :label=> 'New Class', :comment=>'New Comment',
                           :properties=>[{:label=>'myprop', :range=>RDF::XSD.string}, {:label=>'myprop2', :range=>RDF::XSD.date}] }

    response.should redirect_to schema_collection_class_path(spec_rdf_id(@collection, true), spec_rdf_id(@class, true))
    @class.reload
    @class.comment.should == 'New Comment'
    @class.properties.size.should == 2
  end

end
