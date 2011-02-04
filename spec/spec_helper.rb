# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

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
end

def seed_test_db!
  load File.join(Rails.root, 'db', 'seeds.rb')
end

def create_test_site(data={})
  @test_site ||= OpenMedia::Site.create!(:url=>'http://test.gov')
  @test_site
end

def create_test_catalog(data={})
  OpenMedia::Catalog.create!({:title=>'Test Catalog', :metadata=>{ }}.merge(data))
end

def create_test_datasource(data={})
  data[:data_type] = create_test_type unless data[:data_type]
  OpenMedia::Datasource.create!({:title=>'Test Dataset'}.merge(data))  
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

def rdf_id(resource)
  if resource.respond_to?(:uri)
    rdf_id(resource.uri)
  elsif resource.instance_of?(RDF::URI)
    CGI.escape(resource.path[1..-1])
  else
    raise "Could not convert #{resource.inspect} to an RDF::URI"
  end
end

require 'open_media/schema/base_spec'
