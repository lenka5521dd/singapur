# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Mongo::Application.config.secret_key_base = '9ba9e2d2922c8c002ebfa40041017c4f438b6242e64ddb36bbb4249f95b4cc569410a3ea37b8b5759b424e370a55d8efc9a7a69d39d1d23f6490c3f0270d03a6'
