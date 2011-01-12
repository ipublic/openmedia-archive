require 'spec_helper'

describe OpenMedia::Schema::Type do

  before(:each) do
    reset_test_db!
    @domain = OpenMedia::Schema::Domain.new(:namespace => "om", :name => "Public Safety")
  end
  
  it 'requires name, identifier, and domain_id to save' do
    type = OpenMedia::Schema::Type.new
    type.save.should be_false
    type.should_not be_valid
    type.errors[:name].should_not be_nil
    type.errors[:idenifier].should_not be_nil
    type.errors[:domain_id].should_not be_nil        
  end

  it 'saves when all required fields are present' do
    type = OpenMedia::Schema::Type.new(:domain=>@domain, :name=>'Test')
    type.valid?
    type.save.should be_true
    type.should be_valid
    type.errors.size.should == 0
  end

  it 'has an array of nested OpenMedia::Schema::Property' do
    type = OpenMedia::Schema::Type.new(:domain=>@domain, :name=>'Test')
    type.type_properties.size.should == 0

    type.type_properties << OpenMedia::Schema::Property.new(:name=>'aTest', :type=>type)
    type.type_properties.size.should == 1
  end
  

end
