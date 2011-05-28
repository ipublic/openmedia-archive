require 'spec_helper'

describe Schema::Collection do

  before(:each) do
    @site_iri = "http://dc.gov/"
    @collection = Schema::Collection.new(:label=>"Education", :tags=>["schools", "teachers", "students"], 
                                         :comment => "Matters associated with public schools",
                                         :namespace => Schema::Namespace.new(:alias => "dcgov",
                                                                             :iri_base => @site_iri))
  end
  
  it 'should save and generate an identifier correctly' do
    lambda { @collection.save! }.should change(Schema::Collection, :count).by(1)
    @collection.label.should == "Education"
    @collection.identifier.should == 'schema::collection_dcgov_education'
  end
  
  it "should use iri_base view to return matching docs" do
    @collection.save!
    @res = Schema::Collection.by_iri_base(:key => @site_iri)
    @res[0].identifier.should == 'collection_dcgov_education'
  end
  
  it 'should use tags view to return matching docs' do
    @collection.save!
    @res = Schema::Collection.by_tags(:key => "fire")
    @res.length.should == 0 
    @res = Schema::Collection.by_tags(:key => "teachers")
    @res[0].identifier.should == 'collection_dcgov_education'
  end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
