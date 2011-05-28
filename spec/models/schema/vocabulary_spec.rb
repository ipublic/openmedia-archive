require 'spec_helper'

describe Schema::Vocabulary do

  before(:each) do
    @site_namespace = Schema::Namespace.new(:alias => "dcgov", :iri_base => @site_iri)
    @collection = Schema::Collection.new(:label=>"Education", :tags=>["schools", "teachers", "students"], 
                                         :comment => "Matters associated with public schools",
                                         :namespace => @site_namespace)
    @label = "Crime Reports"
    @vocabulary = Schema::Vocabulary.new(:label => @label, :tags => ["police", "crime", "offence"], 
                                         :comment => "Crime incidents",
                                         :collection => @collection,
                                         :namespace => @site_namespace)
  end
  
  it 'should save and generate an identifier correctly' do
    lambda { @vocabulary.save! }.should change(Schema::Vocabulary, :count).by(1)
    @res = Schema::Vocabulary.by_label(:key => @label)
    @res[0].identifier.should == 'schema::vocabulary_dcgov_crime_reports'
  end
  
  it "should use iri_base view to return matching docs" do
    @vocabulary.save!
    @res = Schema::Vocabulary.by_iri_base(:key => @site_namespace["iri_base"])
    @res[0].identifier.should == 'vocabulary_dcgov_crime_reports'
  end
  
  it 'should use tags view to return matching docs' do
    @vocabulary.save!
    @res = Schema::Vocabulary.by_tags(:key => "xyxyxy")
    @res.length.should == 0 
    @res = Schema::Vocabulary.by_tags(:key => "police")
    @res[0].identifier.should == 'vocabulary_dcgov_crime_reports'
  end

  it "should use has_geometry view to return matching docs" do
    @vocabulary.save!
    @res = Schema::Vocabulary.by_has_geometry.length.should == 0
    @vocabulary.geometries << GeoJson::Point.new(GeoJson::Position.new([30, 60]))
    @res = Schema::Vocabulary.by_has_geometry.length.should == 1
  end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
