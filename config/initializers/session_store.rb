# Be sure to restart your server when you modify this file.

# Configure session store with subdomain support
Sp5::Application.config.session_store :cookie_store,
  key: '_streetprint_session',
  domain: case Rails.env.to_sym
  when :development, :test
    '.localhost'  # Share cookies across *.localhost subdomains
  when :production
    '.streetprint.org'  # Share cookies across *.streetprint.org subdomains
  else
    :all
  end
