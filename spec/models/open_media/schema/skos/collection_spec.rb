# require 'spec_helper'
# require 'open_media/schema/skos/collection'
# 
# describe OpenMedia::Schema::SKOS::Collection do
#   
#   before(:each) do
#     @site = create_test_site
#     @collection = @site.skos_collection
#   end
#   
#   it 'should have a label property which is required' do
#     @collection.label.should_not be_nil
#     @collection.label=nil
#     lambda { @collection.save! }.should raise_error
#     @collection.errors.any_for?('label').should_not be_nil
#   end
# 
#   it 'should be able to hold other collections' do
#     @collection1 = OpenMedia::Schema::SKOS::Collection.for(@collection.uri/'crime', :label=>'Crime')
#     @collection1.save!
#     @collection2 = OpenMedia::Schema::SKOS::Collection.for(@collection.uri/'transportation', :label=>'Transportation')
#     @collection2.save!    
#     @collection.members = [@collection1.uri, @collection2.uri]
#     @collection.save!
#     
#     @collection.reload
#     @collection.sub_collections.size.should == 2
#     @collection.sub_collections.collect{|c| c.label}.sort.should == %w(Crime Transportation)
#     @collection.sub_collections.each {|m| m.should be_instance_of(OpenMedia::Schema::SKOS::Collection)}
#   end
# 
#   it 'should be able to hold concepts (which are rdfs:Classes)' do
#     @concept1 = OpenMedia::Schema::SKOS::Concept.for(@collection.uri/'crime', :label=>'Crime')
#     @concept1.save!
#     @concept2 = OpenMedia::Schema::SKOS::Concept.for(@collection.uri/'transportation', :label=>'Transportation')
#     @concept2.save!    
#     @collection.members = [@concept1.uri, @concept2.uri]
#     @collection.save!
#     
#     @collection.reload
#     @collection.concepts.size.should == 2
#     @collection.concepts.each {|m| m.should be_instance_of(OpenMedia::Schema::SKOS::Concept)}
#   end
# 
#   describe 'create_in_collection' do
#     
#     it 'should creates collection in a collection with label' do
#       sub_collection = OpenMedia::Schema::SKOS::Collection.create_in_collection!(@collection, :label=>'Public Safety')      
#       sub_collection.reload
#       sub_collection.uri.should == @collection.uri/'public_safety'
#       sub_collection.label.should == 'Public Safety'
#       @collection.reload
#       @collection.sub_collections.size.should == 1
#     end
# 
#     it 'should not allow multiple collections to be created with same label' do
#       OpenMedia::Schema::SKOS::Collection.create_in_collection!(@collection, :label=>'Public Safety')      
#       lambda { OpenMedia::Schema::SKOS::Collection.create_in_collection!(@collection, :label=>'Public Safety') }.should raise_error
#     end
#     
#   end
# 
# 
#   it 'should have convenience method to remove a member and save' do
#     original_size = @collection.members.size
#     member_uri = RDF::URI.new('http://foo.bar')
#     @collection.members << member_uri
#     @collection.save!
#     @collection.reload
#     @collection.members.size.should == original_size + 1
#     @collection.delete_member!(member_uri)
#     @collection.reload
#     @collection.members.size.should == original_size
#   end
# 
#   describe 'sub-collections' do
#     before(:each) do
#       @sub_collection = OpenMedia::Schema::SKOS::Collection.for(@collection.uri/'crime', :label=>'Crime')
#       @sub_collection.save!
#     end
# 
#     it 'should be able to generate an identifier based on label' do
#       @sub_collection.identifier.should == @sub_collection.uri.path.split('/').last
#     end
#     
#     it "should register the RDF::CouchDB::Repository for the collection's classes with spira" do
#       @sub_collection.repository.should == "#{@site.identifier}_#{@sub_collection.identifier}"
#       Spira.repository(@sub_collection.repository).instance_variable_get("@database").name.should == "#{@site.identifier}_#{@sub_collection.identifier}"
#     end
#   end
# 
#   it_should_behave_like OpenMedia::Schema::Base do
#     let(:base) { @collection }
#   end  
#   
# end
