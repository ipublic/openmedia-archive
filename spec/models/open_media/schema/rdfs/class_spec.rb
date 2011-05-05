require 'spec_helper'

describe OpenMedia::Schema::RDFS::Class do

  before(:each) do
    @site = create_test_site
    @rdfs_class = create_test_rdfs_class(:label=>'Test Class')
  end
  
  it 'should have label, comment, rdf:type' do
    @rdfs_class.label.should_not be_nil
    @rdfs_class.comment.should_not be_nil
  end

  it 'should create class in site and also create skos concept' do    
    @rdfs_class.reload
    @rdfs_class.uri.should == "http://data.civicopenmedia.org/#{@site.identifier}/classes/test_class"
    TYPES_RDF_REPOSITORY.query(:subject=>@rdfs_class.subject, :predicate=>RDF.type).size.should == 2
    TYPES_RDF_REPOSITORY.query(:subject=>@rdfs_class.subject, :predicate=>RDF.type, :object=>RDF::SKOS.Concept).size.should == 1
  end

  it 'should have list of properties, including properties of with type of other classes' do
    rdfs_class2 = create_test_rdfs_class(:label=>'Test Class 2')
    prop1 = OpenMedia::Schema::RDF::Property.create_in_class!(@rdfs_class, :label=>'Property 1', :range=>rdfs_class2.uri)
    prop2 = OpenMedia::Schema::RDF::Property.create_in_class!(@rdfs_class, :label=>'Property 2', :range=>RDF::XSD.string)
    @rdfs_class.properties.size.should == 2
    @rdfs_class.properties.each{|p| p.should be_instance_of(OpenMedia::Schema::RDF::Property)}
  end

  it 'should be able to build a spira resource to manage instances of the class' do
    @rdfs_class.spira_resource.properties.keys.collect{|k| k.to_s}.sort.should == %w(created modified property_1 property_2)    
    @rdfs_class.spira_resource.should == OpenMedia::Schema::RDFS::Class::HttpDataCivicopenmediaOrgTestgovClassesTest_class
    @rdfs_class.spira_resource.should_not be_nil    
    @rdfs_class.spira_resource.default_source(@rdfs_class.skos_concept.collection.repository)
  end

  it 'should be able to retrieve its skos concept' do
    @rdfs_class.skos_concept.should be_instance_of(OpenMedia::Schema::SKOS::Concept)
    @rdfs_class.skos_concept.uri.should == @rdfs_class.uri
  end

  it 'should delegate new and for methods to spira_resource for creating and finding instances' do
    @rdfs_class.new(:property_2=>['Chief']).should be_instance_of(@rdfs_class.spira_resource)
    @rdfs_class.for('http://foo.bar', :property_2=>['Yeah']).should be_instance_of(@rdfs_class.spira_resource)      
  end
  

  # it_should_behave_like OpenMedia::Schema::Base do
  #   let(:base) { @rdfs_class }
  # end  

  it 'should have class method for searching classes and datatypes' do
    OpenMedia::Schema::RDFS::Class.prefix_search('test').size.should == 2
    OpenMedia::Schema::RDFS::Class.prefix_search('test').first.should be_instance_of(RDF::URI)
  end

  it 'should have method to efficiently get count of instances' do
    @rdfs_class.instance_count.should == @rdfs_class.spira_resource.count
  end

  it 'should delete imported data when datasource is deleted' do
    num_records = @rdfs_class.spira_resource.count
    lambda { @rdfs_class.destroy! }.should change(@rdfs_class.spira_resource, :count).by(-num_records)
  end

end
