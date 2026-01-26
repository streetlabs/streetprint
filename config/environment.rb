# Load the rails application
require File.expand_path('../application', __FILE__)

# Require Liquid early for liquid_methods
require 'liquid'

# Initialize the rails application
Sp5::Application.initialize!

APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

# Mail Settings
# Mail Settings
ActionMailer::Base.default_url_options[:host] = "streetprint.org"
ActionMailer::Base.delivery_method = :smtp

 ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,
    :tls => true,
    :address => "smtp.gmail.com",
    :port => "587",
    :domain => "streetprint.org",
    :authentication => :plain,
    :user_name => "noreply@streetprint.org",
    :password => "notachance"
  }
