# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :session_key => '_haypista_session_id',
  :secret      => 'b4d2438fda6abd1f165ffda8da6994c2a17a754ed413c416a21ba2b1c749c396364b600f119bdef224d9e8e80d33868b3d63f0f4a1fb6f5b46f9f6071dcb8115'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
