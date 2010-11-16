require 'spec_helper'


describe OpenMedia::Dataset do

  before(:each) do
    reset_test_db!
    @dataset = OpenMedia::Dataset.create(:name=>'4. Crime Test 3')    
  end
  
  it 'should be a mongodb design document' do
    @dataset.should be_a_kind_of CouchRest::Design      
  end
  
  it 'should save and generate id as _design/ClassName' do
    @dataset.persisted?.should be_true
    @dataset.id.should == '_design/CrimeTest3'
  end

  it 'should generate a design document for querying Datasets' do
    OpenMedia::Dataset.design_doc.id.should_not be_nil
  end

  describe 'validation' do
    it 'should require a name' do
      lambda{ OpenMedia::Dataset.create! }.should raise_error
    end
  end
  
end
