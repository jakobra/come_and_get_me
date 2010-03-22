set :application, "come_and_get_me"

set :host, "jakobra.se"

set :user, "deploy"
set :use_sudo, false
set :deploy_to, "/var/www/#{application}"
set :ssh_options, {:forward_agent => true}

set :scm, :git
set :repository,  "git@github.com:jakobra/Come-And-Get-Me.git"
set :branch, "master"
set :deploy_via, :remote_cache

role :web, "jakobra.se"                   # Your HTTP server, Apache/etc
role :app, "jakobra.se"                   # This may be the same as your `Web` server
role :db,  "jakobra.se", :primary => true # This is where Rails migrations will run

set :rails_env, "staging"

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
    run "ln -nfs #{shared_path}/public/assets #{release_path}/public"
  end
  
  task :rake_gems do
    run "sudo rake gems:install"
  end
  
  task :config do
    system "scp config/config.yml #{user}@#{host}:/#{deploy_to}/shared/config/"
    system "scp config/database.yml #{user}@#{host}:/#{deploy_to}/shared/config/"
  end
  
end

after "deploy:update_code", "deploy:symlink_shared"