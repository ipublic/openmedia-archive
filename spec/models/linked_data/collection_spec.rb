require 'spec_helper'

describe LinkedData::Collection do

  before(:each) do
    VOCABULARIES_DATABASE.recreate! rescue nil
    @ns = LinkedData::Namespace.new("http://dcgov.civicopenmedia.us")
    @term = "education"
    @authority = @ns.authority
    @base_uri = @ns.base_uri
    @collection = LinkedData::Collection.new(:term => @term,
                                             :label => "Education", 
                                             :namespace => @ns,
                                             :tags => ["schools", "teachers", "students"], 
                                             :comment => "Matters associated with public schools")
                                             
    @col_uri = @ns.base_uri + '/collections#' + @term
    @col_id = "collection_civicopenmedia_us_dcgov_education"
  end
  
  it 'should fail to initialize instance without a term, base_uri and authority propoerties' do
    @v = LinkedData::Vocabulary.new
    @v.should_not be_valid
    @v.errors[:term].should_not be_nil
    @v.errors[:authority].should_not be_nil
    @v.errors[:base_uri].should_not be_nil
    lambda { LinkedData::Collection.create!(:term => @term, :base_uri => @base_uri, :authority => @authority) }.should_not raise_error
raise_error
  end


  it 'should save and generate an identifier correctly' do
    lambda { @collection.save! }.should change(LinkedData::Collection, :count).by(1)
  end
  
  it 'should generate a Label view and return results correctly' do
    @res = @collection.save
    @col = LinkedData::Collection.find_by_label(@res.label)
    @col.id.should == @col_id
  end

  it 'should generate a URI for the new collection' do
    @res = @collection.save
    @col = LinkedData::Collection.get(@res.id)
    @col.uri.should == @col_uri
  end
  
  it 'should provide a view by base_uri' do
    @res = @collection.save
    @col = LinkedData::Collection.by_base_uri(:key => @ns.base_uri)
    @col.length.should be > 0
    @col.rows.first.key.should == @ns.base_uri
  end
  
  it 'should provide a view by authority' do
    @res = @collection.save
    @col = LinkedData::Collection.by_authority(:key => @ns.authority)
    @col.length.should be > 0
    @col.rows.first.key.should == @ns.authority
  end
  
  it 'should use tags view to return matching docs' do
    @collection.save!
    @res = LinkedData::Collection.tag_list(:key => "fire")
    @res.length.should == 0 
    @res = LinkedData::Collection.tag_list(:key => "teachers")
    @res.rows.first.id.should == @col_id
  end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
