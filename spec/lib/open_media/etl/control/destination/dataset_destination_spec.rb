require 'spec_helper'

describe OpenMedia::ETL::Control::DatasetDestination do

  before :all do
    create_test_csv
  end

  after :all do
    delete_test_csv
  end
  
  before :each do
    reset_test_db!
    @control = OpenMedia::ETL::Control::Control.new(StringIO.new)
    @control.sources << OpenMedia::ETL::Control::EnumerableSource.new(@control, {:type=>:enumarable,
                                                                        :enumerable=>[{'A'=>1, 'B'=>2, 'C'=>'3', 'D'=>4}]}, { })
    @dataset = create_test_dataset(:title=>'Test')
    OpenMedia::ETL::Engine.init
    OpenMedia::ETL::Engine.import = OpenMedia::Import.create!    
  end
  
  it 'should require :dataset in configuration' do
    lambda {
      OpenMedia::ETL::Control::DatasetDestination.new(@control, {}, {:order=>[:A, :B, :C]})
    }.should raise_error(OpenMedia::ETL::ControlError)
  end
  
  it 'should require dataset in :dataset to actually exist' do
    lambda {
      OpenMedia::ETL::Control::DatasetDestination.new(@control, {:dataset=>'Test2'}, {:order=>[:A, :B, :C]})
    }.should raise_error(OpenMedia::ETL::ControlError)    
  end
  
  it 'should flush data by creating dataset model documents and sending to couchdb/_bulk_docs' do
    @dest = OpenMedia::ETL::Control::DatasetDestination.new(@control, {:dataset=>'Test'}, {:order=>[:A, :B, :C]})
    @dest.write({'A'=>1, 'B'=>2, 'C'=>3, 'D'=>4})
    @dest.flush
    @dataset.model.count.should == 1
    @dataset.model.first.import.should_not be_nil    
    @dataset.model.first.created_at.should_not be_nil
    @dataset.model.first.updated_at.should_not be_nil    
  end


end
