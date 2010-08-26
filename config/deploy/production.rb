set :rails_env, "production"
set :deploy_to, "/var/www/#{application}/#{rails_env}"
set :branch, "release_branch"