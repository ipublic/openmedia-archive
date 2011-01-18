require 'spec_helper'

describe OpenMedia::Schema::Domain do

  before(:each) do
    reset_test_db!
    @site = create_test_site
    @domain = OpenMedia::Schema::Domain.new(:name => "Public Safety", :site=>@site)
  end
  
  it 'requires name to save' do
    d2 = OpenMedia::Schema::Domain.new
    d2.save.should be_false
    d2.should_not be_valid
    d2.errors[:name].should_not be_nil
  end

  it 'given a url and name, should generate an ID in correct format' do
    @domain.identifier.should == "public_safety"
  end

  it 'should have convenience methods for finding core types domain' do
    seed_test_db!
    OpenMedia::Schema::Domain.default_types.site.should be_nil
    OpenMedia::Schema::Domain.default_types.name.should == 'Types'
  end
  
  it 'should require IDs to be unique' do
    @domain.save.should be_true
    d2 = OpenMedia::Schema::Domain.new(:name => "Public Safety")
    d2.save.should be_false
    d2.should_not be_valid
    d2.errors[:name].should_not be_nil
  end

  it 'should know how many types it has' do
    seed_test_db!
    types_domain = OpenMedia::Schema::Domain.find_by_identifier('types')
    types_domain.type_count.should == 4
  end

  it 'should create a CouchDB database named name_space_identifier' do
    @domain.save
    COUCHDB_SERVER.available_database?("#{@site.identifier}_#{@domain.identifier}").should be_true
  end

end
