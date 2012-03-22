# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_xvicen_session',
  :secret      => 'edf43e4cb438ed37c8a4a39a571f230c0539ed7ac2a094c3b6712be1f13bf27806e733e26c5471561ba84a092a2c862cdc7d51b1cb71cc5cde6df31916796d8e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
