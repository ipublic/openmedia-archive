# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'open_media/schema/rdfs/class'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true
end

def reset_test_db!
  SITE_DATABASE.recreate!
  OpenMedia::Site.instance_variable_set(:@instance, nil)
  STAGING_DATABASE.recreate!
  TYPES_DATABASE.recreate!
  TYPES_RDF_REPOSITORY.refresh_design_doc
  OpenMedia::Schema::RDFS::Class.refresh_design_doc
end

def seed_test_db!
  load File.join(Rails.root, 'db', 'seeds.rb')
end

def create_test_site(data={})
  @test_site ||= OpenMedia::Site.create!(:url=>'http://test.gov')
end

def create_test_collection(data={})
  unless @test_collection
    @test_collection = OpenMedia::Schema::SKOS::Collection.for(create_test_site.skos_collection.uri/'testcollection', :label=>'Test Collection')
    @test_collection.save!
  end
  @test_collection
end


def create_test_rdfs_class(data={})
  properties = data.delete(:properties)
  collection = create_test_collection
  c = OpenMedia::Schema::RDFS::Class.create_in_site!(create_test_site, {:label=>'Reported Crimes', :comment=>'crime reports, etc'}.merge(data))
  if properties
    for p in properties
      c.properties << OpenMedia::Schema::RDF::Property.create_in_class!(c, p.merge(:domain=>c))
    end
    c.save!
  end
  collection.members << c.uri
  collection.save!
  c
end

def create_test_owl_class(data={})
  object_properties = data.delete(:object_properties)
  collection = create_test_collection
  c = OpenMedia::Schema::OWL::Class.create_in_site!(create_test_site, {:label=>'Reported Crimes', :comment=>'crime reports, etc'}.merge(data))
  if object_properties
    for p in object_properties
      c.object_properties << OpenMedia::Schema::OWL::ObjectProperty.create_in_class!(c, p)
    end
    c.save!
  end
  c
end


def create_test_catalog(data={})
  OpenMedia::Catalog.create!({:title=>'Test Catalog', :metadata=>{ }}.merge(data))
end

def create_test_datasource(data={})
  data[:rdfs_class_uri] = create_test_rdfs_class.uri unless data[:rdfs_class_uri]
  ds = OpenMedia::Datasource.create!({:title=>'Test Dataset',
                                       :source_type=>OpenMedia::Datasource::FILE_TYPE,
                                       :parser=>OpenMedia::Datasource::DELIMITED_PARSER,
                                       :skip_lines=>1}.merge(data))

end

def create_test_csv
  File.open('/tmp/test.csv', 'w') do |f|
    f.puts('A,B,C,D')
    f.puts('1,2,3,4')
    f.puts('5,6,7,8')            
  end
end

def delete_test_csv
  File.delete('/tmp/test.csv')      
end

def spec_rdf_id(resource, cgi_escape = false)
  if resource.respond_to?(:uri)
    spec_rdf_id(resource.uri, cgi_escape)
  elsif resource.instance_of?(RDF::URI)
    cgi_escape ? CGI.escape(resource.path[1..-1]) : resource.path[1..-1]
  else
    raise "Could not convert #{resource.inspect} to an RDF::URI"
  end
end

require 'open_media/schema/base_spec'

