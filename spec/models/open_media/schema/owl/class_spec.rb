require 'spec_helper'
require 'open_media/schema/owl/class'

describe OpenMedia::Schema::OWL::Class do

  before(:each) do
    @site = create_test_site
    @collection = create_test_collection(:site=>@site)
    @owl_class = create_test_owl_class(:label=>'Test Class', :site=>@site)
    @owl_class2 = create_test_owl_class(:label=>'Test Class 2', :site=>@site)
    @property1 = OpenMedia::Schema::OWL::ObjectProperty.create_in_class!(@owl_class, :label=>'Property 1', :range=>@owl_class2.uri)
    @property2 = OpenMedia::Schema::OWL::ObjectProperty.create_in_class!(@owl_class, :label=>'Property 2', :range=>@owl_class2.uri)
    @property3 = OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(@owl_class, :label=>'Property 3', :range=>RDF::XSD.string)
    @property4 = OpenMedia::Schema::OWL::DatatypeProperty.create_in_class!(@owl_class, :label=>'Property 4', :range=>RDF::XSD.string)    
  end
  
  it 'should have label, comment, rdf:type' do
    @owl_class.label.should_not be_nil
    @owl_class.comment.should_not be_nil
  end

  it 'should create class in site and also create skos concept' do    
    @owl_class.reload
    @owl_class.uri.should == "http://data.civicopenmedia.org/#{@site.identifier}/classes/test_class"
  end

  it 'should have separate list of object_properties and datatype_properties' do
    @owl_class.object_properties.size.should == 2
    @owl_class.object_properties.each{|p| p.should be_instance_of(OpenMedia::Schema::OWL::ObjectProperty)}
    @owl_class.datatype_properties.size.should == 2
    @owl_class.datatype_properties.each{|p| p.should be_instance_of(OpenMedia::Schema::OWL::DatatypeProperty)}
  end
  
  it 'should be able to build a spira resource to manage instances of the class' do
    @owl_class.spira_resource.properties.keys.collect{|k| k.to_s}.sort.should == %w(created modified property_1 property_2 property_3 property_4)    
    @owl_class.spira_resource.should == OpenMedia::Schema::OWL::Class::HttpDataCivicopenmediaOrgTestgovClassesTest_class
    @owl_class.spira_resource.should_not be_nil
    @owl_class.spira_resource.repository.should be_instance_of(RDF::CouchDB::Repository)
  end  

  it_should_behave_like OpenMedia::Schema::Base do
    let(:base) { @owl_class }
  end

  describe 'VCard RDF Support' do
    before(:each) do
      @addr_class = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Address)
      @name_class = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Name)
      @org_class = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.Organization)
      @vcard_class = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard)                  
    end
    
    it 'should have VCard#Address class with relevant properties' do
      @addr_class.should_not be_nil
      @addr_class.datatype_properties.size.should be > 0
      @addr_class.datatype_properties.detect{|p| p.uri==RDF::VCARD['street-address']}.should_not be_nil
    end

    it 'should have VCard#Name class with relevant properties' do
      @name_class.should_not be_nil
      @name_class.datatype_properties.size.should be > 0
      @name_class.datatype_properties.detect{|p| p.uri==RDF::VCARD['given-name']}.should_not be_nil
    end    

    it 'should have VCard#Organization class with relevant properties' do
      @org_class.should_not be_nil
      @org_class.datatype_properties.size.should be > 0
      @org_class.datatype_properties.detect{|p| p.uri==RDF::VCARD['organization-name']}.should_not be_nil
    end

    it 'should have VCard#VCard class with relevant properties' do
      @vcard_class.should_not be_nil
      @vcard_class.datatype_properties.size.should be > 0
      @vcard_class.datatype_properties.detect{|p| p.uri==RDF::VCARD['title']}.should_not be_nil      
      @vcard_class.object_properties.size.should be > 0      
      @vcard_class.object_properties.detect{|p| p.uri==RDF::VCARD['adr']}.should_not be_nil
    end

    it 'should be able to store and retrieve vcards' do
      dan_name = @name_class.new(:given_name=>'Dan', :family_name=>'Thomas').save!
      dan = @vcard_class.for("http://data.civicopenmedia.org/ipublicorg/dthomas", {:n=>dan_name}).save!

      dan2 = @vcard_class.for("http://data.civicopenmedia.org/ipublicorg/dthomas")
      dan2.n.should_not be_nil
      dan2.n.given_name.should == 'Dan'
    end
  end
end
