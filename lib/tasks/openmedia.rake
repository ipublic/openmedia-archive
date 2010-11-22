namespace :openmedia do

    desc "Seed the couchdb database with once/ and always/ fixtures."
    task :seed => :environment do 
      load File.join(Rails.root, 'db', 'seeds.rb')
    end

end
