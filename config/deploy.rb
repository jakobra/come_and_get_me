set :stages, %w(staging production)

set :default_stage, "staging"

require 'capistrano/ext/multistage'
require 'rvm/capistrano'

set :application, "come_and_get_me"

set :normalize_asset_timestamps, false

set :host, "jakobra.se"

set :user, "deploy"
set :use_sudo, false
set :ssh_options, {:forward_agent => true}

set :scm, :git
set :repository,  "git@github.com:jakobra/Come-And-Get-Me.git"
set :deploy_via, :remote_cache

set :keep_releases, 5

role :web, "jakobra.se"                   # Your HTTP server, Apache/etc
role :app, "jakobra.se"                   # This may be the same as your `Web` server
role :db,  "jakobra.se", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run <<-CMD
      if [[ -f #{release_path}/tmp/pids/passenger.#{passenger_port}.pid ]];
      then
        cd #{deploy_to}/current && passenger stop -p #{passenger_port};
      fi
    CMD
    run "cd #{deploy_to}/current && passenger start -e #{rails_env} -p #{passenger_port} -d"
  end
  
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
    run "ln -nfs #{shared_path}/public/content #{release_path}/public"
    run "ln -nfs #{shared_path}/public/google15c02b50c0cc5f0b.html #{release_path}/public/google15c02b50c0cc5f0b.html"
  end
  
  task :sync_assets do
    system "scp -r public/content  #{user}@#{host}:/#{deploy_to}/shared/public/"
  end
  
  task :config do
    system "scp -r config/config.yml #{user}@#{host}:/#{deploy_to}/shared/config/config.yml"
    system "scp -r config/database.yml #{user}@#{host}:/#{deploy_to}/shared/config/database.yml"
  end
  
  task :bundle_install do
    run "cd #{release_path}; bundle install"
  end
  
  task :pipeline_precompile do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
end

after "deploy:update_code", "deploy:bundle_install", "deploy:symlink_shared", "deploy:pipeline_precompile"

after "deploy:restart", "deploy:cleanup"