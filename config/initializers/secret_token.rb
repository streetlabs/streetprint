# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Sp5::Application.config.secret_token = '80d36dbf5441e319b671bf3d084f2455eccf2d5d89dfe89eebaf21f85444bdd4d0284bdda4de59dd5ea6dacfd082539265d3848862953f56ba147f8e2c722a5b'

# Rails 4.0 requires secret_key_base for encrypted cookies
Sp5::Application.config.secret_key_base = '80d36dbf5441e319b671bf3d084f2455eccf2d5d89dfe89eebaf21f85444bdd4d0284bdda4de59dd5ea6dacfd082539265d3848862953f56ba147f8e2c722a5b'
