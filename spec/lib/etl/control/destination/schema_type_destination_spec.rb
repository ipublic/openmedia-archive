require 'spec_helper'

describe ETL::Control::SchemaTypeDestination do

  # before :all do
  #   create_test_csv
  # end
  # 
  # after :all do
  #   delete_test_csv
  # end
  # 
  # before :each do
  #   reset_test_db!
  #   @control = ETL::Control::Control.new(StringIO.new)
  #   @control.sources << ETL::Control::EnumerableSource.new(@control, {:schema_type=>:enumarable,
  #                                                                       :enumerable=>[{'A'=>1, 'B'=>2, 'C'=>'3', 'D'=>4}]}, { })
  #   @type = create_test_type(:title=>'Test')
  #   ETL::Engine.init
  #   ETL::Engine.import = OpenMedia::Import.create!    
  # end
  # 
  # it 'should require :schema_type in configuration' do
  #   lambda {
  #     ETL::Control::SchemaTypeDestination.new(@control, {}, {:order=>[:A, :B, :C]})
  #   }.should raise_error(ETL::ControlError)
  # end
  # 
  # it 'should require type in :schema_type to actually exist' do
  #   lambda {
  #     ETL::Control::SchemaTypeDestination.new(@control, {:schema_type=>'abcd'}, {:order=>[:A, :B, :C]})
  #   }.should raise_error(ETL::ControlError)    
  # end
  # 
  # it 'should flush data by creating rdf statement documents and sending to couchdb/_bulk_docs' do
  #   @dest = ETL::Control::SchemaTypeDestination.new(@control, {:schema_type=>@type.id}, {:order=>[:A, :B, :C]})
  #   @dest.write({'A'=>1, 'B'=>2, 'C'=>3, 'D'=>4})
  #   @dest.flush
  #   @type.model.count.should == 1
  #   @type.model.first.import.should_not be_nil    
  #   @type.model.first.created_at.should_not be_nil
  #   @type.model.first.updated_at.should_not be_nil    
  # end

  it 'should be renamed to RDFSClassDestination (or something) and import data to RDFS:Class instances'


end
