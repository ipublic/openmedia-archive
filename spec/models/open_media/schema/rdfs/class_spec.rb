require 'spec_helper'
require 'models/open_media/schema/base_spec'

describe OpenMedia::Schema::RDFS::Class do

  before(:all) do
    reset_test_db!
    @site = create_test_site
    @rdfs_class = OpenMedia::Schema::RDFS::Class.create_in_site!(@site, :label=>'Reported Crimes', :comment=>'crime reports, etc')
  end
  
  it 'should have label, comment, rdf:type' do
    @rdfs_class.label.should_not be_nil
    @rdfs_class.comment.should_not be_nil
  end

  it 'should create class in site and also create skos concept' do    
    @rdfs_class.reload
    @rdfs_class.uri.should == "http://data.openmedia.org/#{@site.identifier}/classes/reported_crimes"
    TYPES_RDF_REPOSITORY.query(:subject=>@rdfs_class.uri, :predicate=>RDF.type, :object=>RDF::SKOS.Concept).size.should == 1
  end

  it 'should have list of properties' do
    prop1 = OpenMedia::Schema::RDF::Property.create_in_class!(@rdfs_class, :label=>'Property 1', :range=>RDF::XSD.string)
    prop2 = OpenMedia::Schema::RDF::Property.create_in_class!(@rdfs_class, :label=>'Property 2', :range=>RDF::XSD.string)
    @rdfs_class.properties = [prop1, prop2]
    @rdfs_class.save!
    @rdfs_class.reload
    @rdfs_class.properties.size.should == 2
    @rdfs_class.properties.each{|p| p.should be_instance_of(OpenMedia::Schema::RDF::Property)}
  end

  it 'should have list of properties' do
    prop1 = OpenMedia::Schema::RDF::Property.create_in_class!(@rdfs_class, :label=>'Property 1', :range=>RDF::XSD.string)
    prop2 = OpenMedia::Schema::RDF::Property.create_in_class!(@rdfs_class, :label=>'Property 2', :range=>RDF::XSD.string)
    @rdfs_class.properties = [prop1, prop2]
    @rdfs_class.save!
    @rdfs_class.reload
    @rdfs_class.properties.size.should == 2
    @rdfs_class.properties.each{|p| p.should be_instance_of(OpenMedia::Schema::RDF::Property)}
  end

  it_should_behave_like OpenMedia::Schema::Base do
    let(:base) { @rdfs_class }
  end  

end
