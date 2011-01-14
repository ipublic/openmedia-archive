require 'spec_helper'

describe OpenMedia::Schema::Property do
  before(:each) do
    reset_test_db!
  end
  
  it 'should require name and expected_type' do
    p = OpenMedia::Schema::Property.new
    p.should_not be_valid
    p.errors[:name].should_not be_nil
    p.errors[:expected_type].should_not be_nil    
  end

  it 'should generate an identifier' do
    seed_test_db!
    p = OpenMedia::Schema::Property.new(:name=>'Actual Size', :expected_type=>OpenMedia::Schema::Type.find_by_identifier('integer'))
    p.identifier.should == 'actual_size'
  end
end
