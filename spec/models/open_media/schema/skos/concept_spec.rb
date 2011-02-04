require 'spec_helper'

describe OpenMedia::Schema::SKOS::Concept do
  before(:each) do
    reset_test_db!
    @site = create_test_site
    @collection = @site.skos_collection
  end

  describe 'for an rdfs class' do
    before(:each) do
      @rdfs_class = OpenMedia::Schema::RDFS::Class.create_in_site!(@site, :label=>'Reported Crimes', :comment=>'crime reports, etc')
      @concept = OpenMedia::Schema::SKOS::Concept.for(@rdfs_class.subject).save!
    end
    
    it 'should be able to retrieve its corresponding rdfs class' do
      @concept.rdfs_class.should be_instance_of(OpenMedia::Schema::RDFS::Class)
      @concept.rdfs_class.label.should == 'Reported Crimes'      
    end

    it 'should be addable to a collection' do
      @collection.members << @concept.uri
      @collection.save!
      @collection.reload
      @collection.concepts.first.uri == @concept.uri
      @collection.concepts.first.rdfs_class.label.should == 'Reported Crimes'
    end

    it_should_behave_like OpenMedia::Schema::Base do
      let(:base) { @concept }
    end
  end
end
