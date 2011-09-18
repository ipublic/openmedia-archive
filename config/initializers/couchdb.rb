begin

  env = ENV['RAILS_ENV'] || 'development'

  couchdb_config = YAML::load(ERB.new(IO.read(Rails.root.to_s + "/config/couchdb.yml")).result)[env]

  host      = couchdb_config["host"]      || 'localhost'
  port      = couchdb_config["port"]      || '5984'
  database  = couchdb_config["database"]
  username  = couchdb_config["username"]
  password  = couchdb_config["password"]
  ssl       = couchdb_config["ssl"]       || false
  db_prefix = couchdb_config["database_prefix"] || ""
  db_suffix = couchdb_config["database_suffix"] || ""
  host     = "localhost"  if host == nil
  port     = "5984"       if port == nil
  ssl      = false        if ssl == nil

  protocol = ssl ? 'https' : 'http'
  authorized_host = (username.blank? && password.blank?) ? host :
    "#{CGI.escape(username)}:#{CGI.escape(password)}@#{host}"

rescue

  raise "There was a problem with your config/couchdb.yml file. Check and make sure it's present and the syntax is correct."

else

  COUCHDB_CONFIG = {
    :host_path => "#{protocol}://#{authorized_host}:#{port}",
    :db_prefix => "#{db_prefix}",
    :db_suffix => "#{db_suffix}"
  }

  COUCHDB_SERVER = CouchRest.new COUCHDB_CONFIG[:host_path]

  SITE_DATABASE = COUCHDB_SERVER.database!("site#{db_suffix}")
  STAGING_DATABASE = COUCHDB_SERVER.database!("staging#{db_suffix}")
  VOCABULARIES_DATABASE = COUCHDB_SERVER.database!("vocabularies#{db_suffix}")
  COMMONS_DATABASE = COUCHDB_SERVER.database!("commons#{db_suffix}")    
end

# Set CouchRest Model property term to "model"
CouchRest::Model::Base.configure do |config|
  # config.mass_assign_any_attribute = true
  config.model_type_key = 'model'
end

module CouchRest
  class Database

    # Query a CouchDB view, decorated bt a list. Accepts
    # paramaters as described in http://wiki.apache.org/couchdb/HttpViewApi
    def list(name, params = {}, &block)
      keys = params.delete(:keys)
      name = name.split('/')
      dname = name.shift
      lname = name.shift
      vname = name.join('/')
      url = CouchRest.paramify_url "#{@root}/_design/#{dname}/_list/#{lname}/#{vname}", params
      if keys
        CouchRest.post(url, {:keys => keys})
      else
        if block_given?
          @streamer.view("_design/#{dname}/_list/#{lname}/#{vname}", params, &block)
        else
          CouchRest.get url
        end
      end
    end
    
  end
end
