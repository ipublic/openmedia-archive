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
    p = OpenMedia::Schema::Property.new(:name=>'Actual Size', :expected_type=>OpenMedia::Schema::Domain.default_types.find_type('integer'))
    p.identifier.should == 'actual_size'
  end

  it 'should know its path and uri when embedded in a type' do
    @type = create_test_type
    @property = OpenMedia::Schema::Property.new(:name=>'Actual Size', :expected_type=>OpenMedia::Schema::Domain.default_types.find_type('integer'))
    @type.type_properties << @property
    @property.path.should == "/#{@type.domain.site.identifier}/#{@type.domain.identifier}/#{@type.identifier}##{@property.identifier}"    
    @property.uri.should == "http://openmedia.org/#{@type.domain.site.identifier}/#{@type.domain.identifier}/#{@type.identifier}##{@property.identifier}"
  end
end
