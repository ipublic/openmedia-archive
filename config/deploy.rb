require 'bundler/capistrano'

set :application, "openmedia"
set :repository,  "git@github.com:ipublic/openmedia.git"
set :scm, :git
set :ssh_options, {:forward_agent => true, :keys=>[File.join(ENV["HOME"], ".ssh", "id_dsa")]}
set :deploy_via, :remote_cache
set :branch, 'master'
set :use_sudo, false
set :user, 'ipublic'
set :password, 'I5EvBkW5'
set :deploy_to, '/var/www/html/openmedia/'

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "204.236.227.74"                          # Your HTTP server, Apache/etc
role :app, "204.236.227.74"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
