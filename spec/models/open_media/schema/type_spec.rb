require 'spec_helper'

describe OpenMedia::Schema::Type do

  before(:each) do
    reset_test_db!
    @domain = OpenMedia::Schema::Domain.new(:name_space => "om", :name => "Public Safety")
  end
  
  it 'requires name, identifier, and domain_id to save' do
    type = OpenMedia::Schema::Type.new
    type.save.should be_false
    type.should_not be_valid
    type.errors[:name].should_not be_nil
    type.errors[:idenifier].should_not be_nil
    type.errors[:domain_id].should_not be_nil        
  end

  it 'should save when required fields are present and generate identifier off of name' do
    type = OpenMedia::Schema::Type.new(:domain=>@domain, :name=>'Test Type')
    type.send(:generate_identifier)
    type.save.should be_true
    type.identifier.should == 'test_type'
  end

  it 'has an array of nested OpenMedia::Schema::Property' do
    seed_test_db!
    integer_type = OpenMedia::Schema::Type.find_by_identifier('integer')
    type = OpenMedia::Schema::Type.new(:domain=>@domain, :name=>'Test', :type_properties=>[{:name=>'aTest', :expected_type=>integer_type}])
    type.type_properties.size.should == 1
  end
  

end
