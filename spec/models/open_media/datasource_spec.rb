require 'spec_helper'

describe OpenMedia::Datasource do

  # before(:each) do
  #   reset_test_db!
  #   @type = create_test_type
  #   @datasource = OpenMedia::Datasource.new(:title=>'4. Crime Test 3', :data_type=>@type)
  # end
  #   
  # it 'should require a type' do
  #   @datasource.data_type = nil
  #   @datasource.should_not be_valid
  #   @datasource.errors[:data_type_id].should_not be_nil
  # end
  #             
  # it 'should be searchable by title' do
  #   %w(Apples Applications Bananas).each do |t|
  #     ds = OpenMedia::Datasource.create!(:title=>t, :data_type=>@type)
  #   end
  # 
  #   OpenMedia::Datasource.search('App').size.should == 2
  #   OpenMedia::Datasource.search('Ban').size.should == 1
  # end
  # 
  # describe 'validation' do
  #   it 'should require a title' do
  #     lambda{ OpenMedia::Datasource.create! }.should raise_error
  #   end
  # 
  #   it 'should require titles to be unique' do
  #     @datasource.save!
  #     dd2 = OpenMedia::Datasource.new(:title=>'4. Crime Test 3')
  #     dd2.save.should be_false
  #     dd2.should_not be_valid
  #     dd2.errors[:title].should_not be_nil
  #   end
  # 
  #   it 'should allow updates' do
  #     @datasource.save!
  #     @datasource.metadata = { :description => 'Test test' }
  #     lambda { @datasource.save! }.should_not raise_error
  #   end
  # end  
  # 
  # describe 'metadata' do
  #   it 'should save' do
  #     @datasource.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
  #     @datasource.save
  #     ds = OpenMedia::Datasource.get(@datasource.id)
  #     OpenMedia::Datasource.get(@datasource.id).metadata.title.should == 'Meta Title'
  #   end
  # 
  #   it 'should have creator association' do
  #     creator = OpenMedia::Organization.create!(:name=>'Org 1')
  #     @datasource.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
  #     @datasource.metadata.creator = creator
  #     @datasource.save
  # 
  #     OpenMedia::Datasource.get(@datasource.id).metadata.creator.id.should == creator.id
  #   end
  # 
  #   it 'should have publisher association' do
  #     publisher = OpenMedia::Organization.create!(:name=>'Org 1')
  #     @datasource.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
  #     @datasource.metadata.publisher = publisher
  #     @datasource.save
  # 
  #     OpenMedia::Datasource.get(@datasource.id).metadata.publisher.id.should == publisher.id
  #   end
  # 
  #   it 'should have maintainer association' do
  #     maintainer = OpenMedia::Organization.create!(:name=>'Org 1')
  #     @datasource.metadata = OpenMedia::Metadata.new(:title=>'Meta Title')
  #     @datasource.metadata.maintainer = maintainer
  #     @datasource.save
  # 
  #     OpenMedia::Datasource.get(@datasource.id).metadata.maintainer.id.should == maintainer.id
  #   end
  # 
  # end
  # 
  # describe 'importing' do
  #   before(:each) do
  #     reset_test_db!
  #     seed_test_db!
  #     create_test_csv
  #     @domain = OpenMedia::Schema::Domain.create!(:namespace=>'metropolis', :name=>'Silly Stuff')
  #     @datasource_type = OpenMedia::Schema::Type.create!(:name=>@datasource.title+ ' Type', :domain=>@domain,
  #                                                     :type_properties=>[{:name=>'A', :expected_type=>RDF::XSD.string},
  #                                                                        {:name=>'B', :expected_type=>RDF::XSD.string_type},
  #                                                                        {:name=>'C', :expected_type=>RDF::XSD.string},
  #                                                                        {:name=>'D', :expected_type=>RDF::XSD.string}])
  #     @datasource.data_type = @datasource_type
  #     @datasource.source = OpenMedia::Source.new(:source_type=>OpenMedia::Source::FILE_TYPE,
  #                                             :parser=>OpenMedia::Source::DELIMITED_PARSER,
  #                                             :column_separator=>',',
  #                                             :skip_lines=>1,
  #                                             :source_properties=>[{:name=>'A', :expected_type=>RDF::XSD.string},
  #                                                                        {:name=>'B', :expected_type=>RDF::XSD.string},
  #                                                                        {:name=>'C', :expected_type=>RDF::XSD.string},
  #                                                                        {:name=>'D', :expected_type=>RDF::XSD.string}])
  #     @datasource.save!
  #   end
  # 
  #   after(:each) do
  #     delete_test_csv
  #   end
  # 
  #   it 'should require a file to be passed in options for import from a file source' do
  #     lambda { @datasource.import! }.should raise_error(ETL::ControlError)
  #     lambda { @datasource.import!(:file=>'/tmp/test.csv') }.should_not raise_error(ETL::ControlError)      
  #   end
  # 
  #       
  #   it 'should import data from files using OpenMedia::ETL::Engine' do
  #     count = @datasource.import!({:file=>'/tmp/test.csv'})
  #     count.should == 2
  #     OpenMedia::Import.count.should == 1
  #     OpenMedia::Import.first.created_at.should_not be_nil
  #     OpenMedia::Import.first.status.should == OpenMedia::Import::STATUS_COMPLETED
  #     @datasource.model.count.should == 2
  #   end
  # 
  #   it 'should map source properties to datasource properties properly'
  # 
  #   it 'should do type transformations based on property types'
  # 
  #   it 'should delete imported data when datasource is deleted' do
  #     @datasource.import!({:file=>'/tmp/test.csv'})                        
  #     @datasource = OpenMedia::Datasource.find(@datasource.id)
  #     num_docs = STAGING_DATABASE.documents['rows'].size
  #     @datasource.destroy
  #     STAGING_DATABASE.documents['rows'].size.should == (num_docs - 3)
  #   end
  # 
  # end

  it 'should validate required fields, allow files to be uploaded, and data imported via etl'
  
end
