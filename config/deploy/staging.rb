set :rails_env, "staging"
set :deploy_to, "/var/www/#{application}/#{rails_env}"
set :branch, "master"
set :passenger_port, 6600