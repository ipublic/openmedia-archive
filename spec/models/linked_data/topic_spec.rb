require 'spec_helper'

describe LinkedData::Topic do

  before(:all) do
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    # @address_vocab = LinkedData::Vocabulary.get("vocabulary_openmedia_dev_om_street_address")
    @topic_term = "dc_addresses"
    @design_doc_id = '_design/' + @topic_term.singularize.camelize
    @topic_label = "District of Columbia Addresses"
    @instance_db_name = COMMONS_DATABASE.name

    @prop_names = %W(formatted_address city state)
    @prop_list = @prop_names.inject([]) {|memo, name| memo << LinkedData::Property.new(:term => name)}
    
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
    it 'should fail to initialize instance without term, authority and instance_database_name properties' do
      @topic = LinkedData::Topic.new
      @topic.should_not be_valid
      @topic.errors[:term].should_not be_nil
      @topic.errors[:authority].should_not be_nil
      @topic.errors[:instance_database_name].should_not be_nil
    end
    
    it 'should provide a valid CouchDB database to store instance docs' do
      @topic.instance_database.should be_a(::CouchRest::Database)
    end
    
    it 'should save and generate an identifier correctly' do
      lambda { @topic.save! }.should_not raise_error
      saved_topic = LinkedData::Topic.by_term(:key => @topic_term)
      saved_topic.first.identifier.should == @topic_id
    end
    
  end
  
  describe "vocabulary" do
    it "should provide a list of properties from associated vocabulary" do
      all_props = @prop_names # + %W(updated_at created_at data_source_id serial_number)
      @topic.instance_properties.each {|p| all_props.include?(p.term).should == true}
    end
    
    it "should provide a list of types from associated vocabulary" do
    end
  end
  
  describe "instance methods" do
    before(:all) do
      @model = @topic.couchrest_model
      @model_name = @topic_term.camelize.singularize
      @sn = "abc123"
      @doc = @topic.new_instance_doc(:formatted_address =>"1600 Pennsylvania Ave", 
                                      :city =>"Washington", :state =>"DC", :serial_number => @sn)
      @resp = @topic.instance_database.save_doc @doc
      @saved_doc = @topic.instance_database.get @resp['id']
    end
    
    describe ".instance_design_doc" do
      it 'should create an associated CouchRest::Design document' do
        # dsn = @doc.design_doc
        dsn = @topic.instance_design_doc
        dsn.should be_a(::CouchRest::Design)
        dsn.name.should == @topic_term.singularize.camelize
        dsn["_id"].should == @design_doc_id
        dsn.has_view?(:all).should be_true
      end

      it "should be able to add a view definition" do
        dsn = @topic.instance_design_doc
        lambda{dsn.view @sn_prop_name.to_sym}.should raise_error
        dsn.view_by :serial_number 
        dsn.save
        @topic.instance_design_doc.has_view?("by_serial_number").should == true
      end
    end
    
    describe ".couchrest_model" do
      it "should provide a CouchRest model for the Topic" do
        @model.name.should == @model_name
        @model.superclass.to_s.should == "CouchRest::Model::Base"
      end

      it "should point to the instance database to store docs" do
        @model.database.name.should == @instance_db_name
      end
    end
    
    describe ".new_instance_doc" do
      it "should set the documents model_type_key" do
        @doc['model'].should == @topic_term.camelize.singularize
      end

      it "should initialize properties and save an instance doc correctly" do
        @saved_doc.id.should_not be_nil
        @saved_doc['formatted_address'].should == "1600 Pennsylvania Ave"
        @saved_doc['city'].should == "Washington"
        @saved_doc['state'].should == "DC"
        @saved_doc['serial_number'].should == @sn
      end

      it "should find all instances for this Topic's model" do
        elwood_blues = @topic.new_instance_doc(:formatted_address => "1060 West Addison Street", 
                                               :city =>"Chicago", :state =>"IL", :serial_number => @sn).save
        addr_docs = @topic.instance_design_doc.view(:all)
        addr_docs['total_rows'].should == 2
        saved_doc = @topic.instance_database.get addr_docs['rows'].first['id']
        saved_doc['city'].should == "Chicago"
      end
    end
    
    describe ".destroy_instance_docs!" do
      it "should delete all Topic data documents in instance db" do
        
        ## This spec requires CouchDB configuration delayed_commits = false
        lambda {@topic.instance_database.get @resp['id']}.should_not raise_error
        ct = @topic.destroy_instance_docs!
        ct.should == 2
        lambda {@topic.instance_database.get @resp['id']}.should raise_error
      end
    end
    
  end
  

end