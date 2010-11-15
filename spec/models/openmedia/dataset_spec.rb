require 'spec_helper'


describe Openmedia::Dataset do

  before(:all) do
    reset_test_db!
  end
  
  describe 'validation' do
    it 'should require a name' do
      lambda{ Openmedia::Dataset.create! }.should raise_error
    end
  end

  describe 'the model class' do
    before(:each) do
      @dataset = Openmedia::Dataset.create(:name=>'Crime Incidents')
    end

    it 'should be a mongodb design document' do
      @dataset.should be_a_kind_of CouchRest::Design      
    end    
  end
  
end
