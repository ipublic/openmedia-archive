require 'spec_helper'

describe OpenMedia::Schema::OWL::Class do

  before(:all) do
    reset_test_db!
    @site = create_test_site
    @owl_class = create_test_owl_class(:label=>'Test Class')
    @owl_class2 = create_test_owl_class(:label=>'Test Class 2')    
  end
  
  it 'should have label, comment, rdf:type' do
    @owl_class.label.should_not be_nil
    @owl_class.comment.should_not be_nil
  end

  it 'should create class in site and also create skos concept' do    
    @owl_class.reload
    @owl_class.uri.should == "http://data.civicopenmedia.org/#{@site.identifier}/classes/test_class"
  end

  it 'should have list of object_properties' do
    prop1 = OpenMedia::Schema::OWL::ObjectProperty.create_in_class!(@owl_class, :label=>'Property 1', :range=>@owl_class2.uri)
    prop2 = OpenMedia::Schema::OWL::ObjectProperty.create_in_class!(@owl_class, :label=>'Property 2', :range=>@owl_class2.uri)
    @owl_class.object_properties = [prop1, prop2]
    @owl_class.save!
    @owl_class.reload
    @owl_class.object_properties.size.should == 2
    @owl_class.object_properties.each{|p| p.should be_instance_of(OpenMedia::Schema::OWL::ObjectProperty)}
  end

  it 'should also have list of datatype_properties' do
    prop3 = OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(@owl_class, :label=>'Property 3', :range=>RDF::XSD.string)
    prop4 = OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(@owl_class, :label=>'Property 4', :range=>RDF::XSD.string)
    @owl_class.datatype_properties = [prop3, prop4]
    @owl_class.save!
    @owl_class.reload
    @owl_class.datatype_properties.size.should == 2
    @owl_class.datatype_properties.each{|p| p.should be_instance_of(OpenMedia::Schema::OWL::DatatypeProperty)}
  end
  
  it 'should be able to build a spira resource to manage instances of the class' do
    @owl_class.spira_resource.properties.keys.collect{|k| k.to_s}.sort.should == %w(created modified property_1 property_2 property_3 property_4)    
    @owl_class.spira_resource.should == OpenMedia::Schema::OWL::Class.const_get('TestgovClassTestClas')
    @owl_class.spira_resource.should_not be_nil
    @owl_class.spira_resource.repository.should be_instance_of(RDF::CouchDB::Repository)
  end

  it_should_behave_like OpenMedia::Schema::Base do
    let(:base) { @owl_class }
  end  

end
