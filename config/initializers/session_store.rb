# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_come_and_get_me_session',
  :secret      => '5a0e631bd4904a65c025407bdc0aec243ba7e53d0789cd9e1f2a80da2cb968f144e047f0692db50992030bf17f09037119aaf9bb33e8fcb54f347c61b3058878'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
