# require 'spec_helper'
# 
# describe OpenMedia::Schema::RDF::Property do
#   before(:each) do
#     @site = create_test_site
#     @rdfs_class = OpenMedia::Schema::RDFS::Class.create_in_site!(@site, :label=>'Reported Crimes', :comment=>'crime reports, etc')
#   end
# 
#   describe 'validation' do
#     before(:each) do
#       @property = OpenMedia::Schema::RDF::Property.for('foo')
#     end
# 
#     it 'should require label, range, and domain' do
#       lambda { @property.save! }.should raise_error
#       
#       @property.errors.any_for?('label').should_not be_nil
#       @property.errors.any_for?('range').should_not be_nil
#       @property.errors.any_for?('domain').should_not be_nil            
#     end
#   end
# 
#   describe 'with all required properties' do
#     before(:each) do
#       @property = OpenMedia::Schema::RDF::Property.create_in_class!(@rdfs_class, :label=>'Offense Code', :range=>RDF::XSD.string)
#     end
# 
#     it 'should get created with proper uri' do
#       @property.should exist
#     end
# 
#     it_should_behave_like OpenMedia::Schema::Base do
#       let(:base) { @property }
#     end
#   end  
# 
# end
