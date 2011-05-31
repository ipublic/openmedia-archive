require 'spec_helper'

describe Schema::Collection do

  before(:each) do
    @uri = "http://civicopenmedia.us/vocabulary/"
    @abbrev = "om"
    @site_namespace = Schema::Namespace.new(:uri => @uri, :abbreviation => @abbrev)
    @site_namespace.save!
    @site_id = @site_namespace.identifier
    @collection = Schema::Collection.new(:label=>"Education", :tags=>["schools", "teachers", "students"], 
                                         :comment => "Matters associated with public schools",
                                         :namespace => @site_namespace)
  end
  
  it 'should save and generate an identifier correctly' do
    lambda { @collection.save! }.should change(Schema::Collection, :count).by(1)
    @collection.label.should == "Education"
    @collection.identifier.should == 'collection_civicopenmedia_us_education'
  end
  
  it 'should return this Collection when searching by Namespace' do
    @collection.save!
    @ns = Schema::Namespace.get(@site_id)
    @cols = Schema::Collection.find_by_namespace_id(@ns.identifier)
    @cols[0].label.should == "Education"
  end
  
  it 'should use tags view to return matching docs' do
    @collection.save!
    @res = Schema::Collection.by_tags(:key => "fire")
    @res.length.should == 0 
    @res = Schema::Collection.by_tags(:key => "teachers")
    @res[0].identifier.should == 'collection_civicopenmedia_us_education'
  end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
