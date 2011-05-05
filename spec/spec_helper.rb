require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'devise/test_helpers'
  require 'open_media/schema/rdfs/class'
  require 'open_media/schema/base_spec'
  
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
    config.include Devise::TestHelpers, :type => :controller

    WATCHED_DBS = [SITE_DATABASE, STAGING_DATABASE, TYPES_DATABASE]
    start_sequences = { }
    config.before(:each) do
      WATCHED_DBS.each do |db|
        start_sequences[db] = db.info['update_seq']
      end
    end

    config.after(:each) do
      WATCHED_DBS.each do |db|
        changes = db.get('_changes', :since=>start_sequences[db])
        to_delete = changes['results'].select{|chg| !chg['deleted']}.collect{|chg| {'_id'=>chg['id'], '_rev'=>chg['changes'].first['rev'], '_deleted'=>true}}
        db.bulk_save(to_delete)
      end
    end
  end


end

Spork.each_run do
  # This code will be run each time you run your specs.
  require 'spec_utils'
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.






# def reset_test_db!
#   SITE_DATABASE.recreate!
#   OpenMedia::Site.instance_variable_set(:@instance, nil)
#   STAGING_DATABASE.recreate!
#   TYPES_DATABASE.recreate!
#   TYPES_RDF_REPOSITORY.refresh_design_doc
#   OpenMedia::Schema::DesignDoc.refresh
# end
# 
# def seed_test_db!
#   load File.join(Rails.root, 'db', 'seeds.rb')
#   OpenMedia::Schema::RDFS::Class.for(::RDF::METADATA.Metadata)
#   OpenMedia::Schema::OWL::Class.for(::RDF::VCARD.VCard)
#   OpenMedia::Schema::VCard.initialize_vcard
#   OpenMedia::Schema::Metadata.initialize_metadata  
# end

