require 'spec_helper'

describe OpenMedia::Catalog do

  before(:each) do
    reset_test_db!
    @catalog = OpenMedia::Catalog.new(:title=>'Catalog 4', :database_store=>'staging_test', :metadata=>{ })
  end

  it 'requires title to save' do
    OpenMedia::Catalog.new.should_not be_valid
    OpenMedia::Catalog.new.save.should be_false
  end
  
  it 'should require titles to be unique' do
    @catalog.save
    c2 = OpenMedia::Catalog.new(:title=>'Catalog 4', :database_store=>'staging_test')
    c2.save.should be_false
    c2.should_not be_valid
    c2.errors[:title].should_not be_nil
  end
  
  it 'should save and generate an id correctly' do
    lambda { @catalog.save}.should change(OpenMedia::Catalog, :count).by(1)
    @catalog.id.should == 'catalog_catalog_4'
  end

  it 'should be able to fetch its datasets' do
    @catalog.save
    ds1 = OpenMedia::Dataset.new(:title=>"DS1")
    ds1.catalog_ids = [@catalog.id]
    ds1.save!
    ds2 = OpenMedia::Dataset.new(:title=>"DS2")
    ds2.catalog_ids = [@catalog.id]
    ds2.save!
    @catalog.datasets = [ds1, ds2]
    @catalog = OpenMedia::Catalog.first
    @catalog.dataset_ids.should == [ds1.id, ds2.id]    
  end

end
