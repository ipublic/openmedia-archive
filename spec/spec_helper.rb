$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "bundler/setup"
require "rubygems"
require "rspec"

# require 'couchrest_model'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))

unless defined?(FIXTURE_PATH)
  MODEL_PATH = File.join(File.dirname(__FILE__), "fixtures", "models")
  $LOAD_PATH.unshift(MODEL_PATH)

  FIXTURE_PATH = File.join(File.dirname(__FILE__), '/fixtures')
  SCRATCH_PATH = File.join(File.dirname(__FILE__), '/tmp')

  COUCHHOST = "http://127.0.0.1:5984"
  TESTDB    = 'couchrest-model-test'
  TEST_SERVER    = CouchRest.new COUCHHOST
  COUCHDB_SERVER = TEST_SERVER  # need this for OpenMedia model specs 
  TEST_SERVER.default_database = TESTDB
  DB = TEST_SERVER.database(TESTDB)
end

RSpec.configure do |config|
  config.before(:all) do
    reset_test_db!
    TEST_SITE ||= create_test_site
  end

  config.after(:all) do
    [SITE_DATABASE, STAGING_DATABASE, VOCABULARIES_DATABASE, DB].each { |db| db.delete! rescue nil }
    # cr = TEST_SERVER
    # test_dbs = cr.databases.select { |db| db =~ /^#{TESTDB}/ }
    # test_dbs.each do |db|
    #   cr.database(db).delete! rescue nil
    # end
  end
end

# Require each of the fixture models
 Dir[ File.join(MODEL_PATH, "*.rb") ].sort.each { |file| require File.basename(file) }

class Basic < CouchRest::Model::Base
  use_database TEST_SERVER.default_database
end

# def reset_test_db!
#   DB.recreate! rescue nil 
#   # Reset the Design Cache
#   Thread.current[:couchrest_design_cache] = {}
#   DB
# end

def reset_test_db!
  [SITE_DATABASE, STAGING_DATABASE, VOCABULARIES_DATABASE, DB].each { |db| db.recreate! rescue nil }
  # OpenMedia::Site.instance_variable_set(:@instance, nil)
end

def seed_test_db!
  load File.join(Rails.root, 'db', 'seeds.rb')
end

def om_site
  OpenMedia::Site.find_by_identifier('om')
end

def create_test_site(data={})
  @test_site = OpenMedia::Site.create!({:identifier=>'testgov', :url=>'http://testgov.civicopenmedia.org',
                                         :municipality=>OpenMedia::NamedPlace.new(:name=>'My City')}.merge(data))
  COUCHDB_SERVER.database!("#{@test_site.identifier}_metadata").recreate!
  @test_site
end

def create_test_admin(site)
  Admin.create!(:email=>'test@ipublic.org', :password=>'ChangeMe',
                    :password_confirmation=>'ChangeMe', :site=>site, :confirmed_at=>Time.now)
end


def couchdb_lucene_available?
  lucene_path = "http://localhost:5985/"
  url = URI.parse(lucene_path)
  req = Net::HTTP::Get.new(url.path)
  res = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
  true
 rescue Exception => e
  false
end


