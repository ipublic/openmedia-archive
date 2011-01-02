namespace :openmedia do

  desc "Seed the couchdb database with once/ and always/ fixtures."
  task :seed => :environment do 
    load File.join(Rails.root, 'db', 'seeds.rb')
  end

  desc "create the couchdb databases for the current environment"
  task :create_dbs => :environment do
    SITE_DATABASE.create!
    STAGING_DATABASE.create!
    TYPES_DATABASE.create!
    BASE_DATABASE.create!
  end 

  desc "drop the couchdb databases for the current environment"
  task :drop_dbs => :environment do
    SITE_DATABASE.delete! rescue nil
    STAGING_DATABASE.delete! rescue nil
    TYPES_DATABASE.delete! rescue nil
    BASE_DATABASE.delete! rescue nil
  end

  desc "create couchdb databases and load seeds"
  task :setup => [:environment, :create_dbs, :seed]

  desc "drop couchdb databases, then create couchdb databases and load seeds"
  task :reset => [:environment, :drop_dbs, :create_dbs, :seed]

  
end
