set :stages, %w(staging production)

set :default_stage, "staging"

require 'capistrano/ext/multistage'

set :application, "come_and_get_me"

set :user, "deploy"
set :use_sudo, false
set :ssh_options, {:forward_agent => true}

set :scm, :git
set :repository,  "git@github.com:jakobra/come_and_get_me.git"
set :deploy_via, :remote_cache

role :web, "burton.jakobra.com"                   # Your HTTP server, Apache/etc
role :app, "burton.jakobra.com"                   # This may be the same as your `Web` server
role :db,  "burton.jakobra.com", :primary => true # This is where Rails migrations will run

set :shared_children, %w()

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run <<-CMD
      if [[ -f #{release_path}/tmp/pids/passenger.#{passenger_port}.pid ]];
      then
        cd #{release_path} && ~/.rbenv/bin/rbenv exec bundle exec passenger stop -p #{passenger_port};
      fi
    CMD
    run "cd #{release_path} && ~/.rbenv/bin/rbenv exec bundle exec passenger start -e #{rails_env} -p #{passenger_port} -d"
  end
  
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
    run "ln -nfs #{shared_path}/public/assets #{release_path}/public"
    run "ln -nfs #{shared_path}/public/google15c02b50c0cc5f0b.html #{release_path}/public/google15c02b50c0cc5f0b.html"
    
    run "ln -nfs #{shared_path}/tmp/pids #{release_path}/tmp"
    run "ln -nfs #{shared_path}/log #{release_path}"
  end
  
  task :bundle_install do
    run "cd #{release_path}; ~/.rbenv/bin/rbenv exec bundle install --without development --deployment --quiet --binstubs"
  end
end

after "deploy:update_code", "deploy:bundle_install", "deploy:symlink_shared"