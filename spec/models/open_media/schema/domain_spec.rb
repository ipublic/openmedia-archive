require 'spec_helper'

describe OpenMedia::Schema::Domain do

  before(:each) do
    reset_test_db!
    @domain = OpenMedia::Schema::Domain.new(:namespace => "om", :name => "Public Safety")
  end
  
  it 'requires name to save' do
    d2 = OpenMedia::Schema::Domain.new(:namespace => "om")
    d2.save.should be_false
    d2.should_not be_valid
    d2.errors[:name].should_not be_nil
  end

  it 'requires namespace to save' do
    d2 = OpenMedia::Schema::Domain.new(:name => "Public Safety")
    d2.save.should be_false
    d2.should_not be_valid
    d2.errors[:name].should_not be_nil
  end

  it 'given a namespace and name, should generate an ID in correct format' do
    @domain.identifier.should == "publicsafety"
  end

  it 'should require IDs to be unique' do
    @domain.save
    d2 = OpenMedia::Schema::Domain.new(:namespace => "om", :name => "Public Safety")
    d2.save.should be_false
    d2.should_not be_valid
    d2.errors[:name].should_not be_nil
  end

  it 'should create a CouchDB database named namespace_identifier' do
    @domain.save
    COUCHDB_SERVER.available_database?("#{@domain.namespace}_#{@domain.identifier}").should be_true
  end

end
