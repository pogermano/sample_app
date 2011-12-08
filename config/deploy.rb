$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'capistrano'
require 'bundler/capistrano'

# Use our ruby-1.9.2-p290@my_site gemset
default_environment["PATH"]         = "/usr/share/ruby-rvm/gems/ruby-1.9.2-p290/bin:/usr/share/ruby-rvm/gems/ruby-1.9.2-p290global/bin:/usr/share/ruby-rvm/rubies/ruby-1.9.2-p290/bin:/usr/share/ruby-rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
default_environment["GEM_HOME"]     = "/usr/share/ruby-rvm/gems/ruby-1.9.2-p290"
default_environment["GEM_PATH"]     = "/usr/share/ruby-rvm/gems/ruby-1.9.2-p290:/usr/share/ruby-rvm/gems/ruby-1.9.2-p290@global"
default_environment["RUBY_VERSION"] = "ruby-1.9.2-p290"

#default_run_options[:shell] = 'bash'


set :application, "sample_app"
set :repository,  "git://github.com/pogermano/sample_app.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "192.168.179.141"      # Your HTTP server, Apache/etc
role :app, "192.168.179.141"      # This may be the same as your `Web` server
role :db,  "192.168.179.141", :primary => true #grations will run

set :user, "geofind.com"
set :deploy_to, "/home/geofind.com/apps/#{application}"



set :use_sudo, false
set :keep_releases, 5

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

#default_environment["RAILS_ENV"] = 'production'





# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end

task :symlink_database_yml do
  run "rm #{release_path}/config/database.yml"
  run "ln -sfn #{shared_path}/config/database.yml
       #{release_path}/config/database.yml"
end
after "bundle:install", "sysmlink_database_yml"
  


