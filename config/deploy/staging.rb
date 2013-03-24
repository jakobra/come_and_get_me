set :rails_env, "staging"
set :deploy_to, "/var/www/#{application}/#{rails_env}"
set :branch, "rails3"

set :rvm_ruby_string, '1.9.2@come_and_get_me'
set :passenger_port, 3400