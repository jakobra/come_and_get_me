set :stages, %w(staging production)

set :default_stage, "staging"

require 'capistrano/ext/multistage'

set :application, "come_and_get_me"

set :host, "jakobra.se"

set :user, "deploy"
set :use_sudo, false
set :ssh_options, {:forward_agent => true}

set :scm, :git
set :repository,  "git@github.com:jakobra/Come-And-Get-Me.git"
set :deploy_via, :remote_cache

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
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
    run "ln -nfs #{shared_path}/public/assets #{release_path}/public"
  end
  
  task :rake_gems do
    run "sudo rake gems:install"
  end
  
  task :sync_assets do
    system "scp -r public/assets  #{user}@#{host}:/#{deploy_to}/shared/public/"
  end
  
  task :config do
    system "scp -r config/config.yml #{user}@#{host}:/#{deploy_to}/shared/config/config.yml"
    system "scp -r config/database.yml #{user}@#{host}:/#{deploy_to}/shared/config/database.yml"
  end
  
  task :disable do
    run "cp public/closed.html public/maintenance.html"
  end
  
  task :enable do
    run "rm public/maintenance.html"
  end
  
end

after "deploy:update_code", "deploy:symlink_shared"