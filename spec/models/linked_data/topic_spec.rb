require 'spec_helper'

describe LinkedData::Topic do

  before(:all) do
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    # @address_vocab = LinkedData::Vocabulary.get("vocabulary_openmedia_dev_om_street_address")
    @topic_term = "dc_addresses"
    @design_doc_id = '_design/' + @topic_term
    @topic_label = "District of Columbia Addresses"
    @instance_db_name = DB.name

    @prop_names = %W(formatted_address city state)
    @prop_list = @prop_names.inject([]) {|memo, name| memo << LinkedData::Property.new(:term => name, :expected_type => RDF::XSD.string.to_s)}
    
    @vocab = LinkedData::Vocabulary.create!(:label => "Street address",
                                            :term => "street_address",
                                            :namespace => @ns,
                                            :property_delimiter => "#",
                                            :curie_prefix => "addr",
                                            :authority => "testgov_civicopenmedia_us",
                                            :properties => @prop_list
                                            )
    
    @topic = LinkedData::Topic.new(:authority => @ns.authority, 
                                    :term => @topic_term, 
                                    :label => @topic_label,
                                    :vocabulary => @vocab,
                                    :instance_database_name => @instance_db_name)
    @topic_id = "topic_civicopenmedia_us_dcgov_dc_addresses"
  end

  describe "initialization" do
    it 'should fail to initialize instance without term and authority properties' do
      @topic = LinkedData::Topic.new
      @topic.should_not be_valid
      @topic.errors[:term].should_not be_nil
      @topic.errors[:authority].should_not be_nil
      @topic.errors[:instance_topic_name].should_not be_nil
    end
    
    it 'should return vocabulary properties' do
      @topic.vocabulary.properties.first.should == @prop_list.first 
    end
    
    it 'should provide a valid CouchDB database to store instance docs' do
      @topic.instance_database.should be_a(::CouchRest::Database)
    end
    
    it 'should save and generate an identifier correctly' do
      lambda { @topic.save! }.should_not raise_error
      saved_topic = LinkedData::Topic.by_term(:key => @topic_term)
      saved_topic.first.identifier.should == @topic_id
    end
    
    it 'should create an associated CouchRest::Design document' do
      saved_topic = LinkedData::Topic.get(@topic_id)
      dsn = saved_topic.instance_design_doc
      dsn.should be_a(::CouchRest::Design)
      dsn.name.should == @topic.term
      dsn["_id"].should == @design_doc_id
      dsn.has_view?(:all).should be_true
    end
  end
  
  describe "instance methods" do
    before(:all) do
      @model = @topic.couchrest_model
      @doc = @topic.new_instance_doc
    end
    
    describe ".couchrest_model" do
      it "should provide a CouchRest model for the Topic" do
        @model.name.should == @topic_term.camelize.singularize
        @model.superclass.to_s.should == "CouchRest::Model::Base"
      end

      it "should point to the instance database to store docs" do
        @model.database.name.should == @instance_db_name
      end
    end
    
    describe ".new_instance_doc" do
      it "should populate properties from the associated Vocabulary" do
        @doc['model'].should == @topic_term.camelize.singularize
        all_props = @prop_names + %W(updated_at created_at)
        @doc.properties.each {|p| all_props.include?(p.to_s).should == true}
      end

      it "should initialize properties and save an instance doc correctly" do
        wh = @topic.new_instance_doc(:formatted_address =>"1600 Pennsylvania Ave", 
                                     :city =>"Washington", :state =>"DC").save
        wh.formatted_address.should == "1600 Pennsylvania Ave"
        wh.city.should == "Washington"
        wh.state.should == "DC"
        wh.id.should_not be_nil
      end

      it "should find all instances for this Topic's model" do
        elwood_blues = @topic.new_instance_doc(:formatted_address => "1060 West Addison Street", 
                                               :city =>"Chicago", :state =>"IL").save
        addr_docs = @model.all
        addr_docs.length.should == 2
        addr_docs.first.city.should == "Chicago"
      end
    end
    
    describe ".destroy_instance_docs!" do
      it "should delete all Topic data documents in instance db" do
        ct = @topic.destroy_instance_docs!
        ct.should == 2
        addr_docs = @model.all
        addr_docs.length.should == 0
      end
    end
    
  end
  

end