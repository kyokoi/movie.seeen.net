# Be sure to restart your server when you modify this file.

MovieSeen::Application.config.session_store :cookie_store, key: '_movie_seen',  :expire_after => 2.month


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# MovieSeen::Application.config.session_store :active_record_store
