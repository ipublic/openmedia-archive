# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'devise/test_helpers'
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

def create_test_site(data={})
  @test_site ||= OpenMedia::Site.create!(:identifier=>'testgov', :url=>'http://test.gov',
                                         :municipality=>OpenMedia::NamedPlace.new(:name=>'My City'))
  COUCHDB_SERVER.database!("#{@test_site.identifier}_metadata").recreate!
  @test_site
end

def create_test_admin(site)
  Admin.create!(:email=>'test@ipublic.org', :password=>'ChangeMe',
                    :password_confirmation=>'ChangeMe', :site=>site, :confirmed_at=>Time.now)
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
                                       :source_type=>OpenMedia::Datasource::TEXTFILE_TYPE,
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

