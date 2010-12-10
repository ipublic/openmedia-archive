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
  STAGING_DATABASE.recreate!
end

def create_test_catalog(data={})
  OpenMedia::Catalog.create!({:title=>'Test Catalog', :metadata=>{ }}.merge(data))
end

def create_test_dataset(data={})
  c = data.delete(:catalog)
  ds = OpenMedia::Dataset.new({:title=>'Test Dataset', :metadata=>{ }, :source=>{ }}.merge(data))  
  ds.catalog_ids = c ? [c.id] : [create_test_catalog.id]
  ds.save!
  return ds
end
