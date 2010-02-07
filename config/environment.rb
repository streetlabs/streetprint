# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/builders )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "authlogic",
    :version => "2.1.1"
    
  config.gem "hoptoad_notifier"
  
  config.gem(
    'thinking-sphinx',
    :lib         => 'thinking_sphinx',
    :version     => '>=1.3.14'
  )
  config.gem 'mislav-will_paginate',
    :version => '2.3.11',
    :lib => 'will_paginate',
    :source => 'http://gems.github.com'
  
  config.gem "paperclip-cloudfiles",
    :lib => 'paperclip',
    :version => '2.3.1.1.0', # newer version broken
    :source => "http://gemcutter.org/"
    
  config.gem 'rdfa',
    :version => '0.0.8'
    
  config.gem "be9-acl9",
  :source => "http://gems.github.com",
  :lib => "acl9",
  :version => "0.10.0"
  
  config.gem 'mbleigh-subdomain-fu',
  :source => "http://gems.github.com",
  :lib => "subdomain-fu"
  
  config.gem 'RedCloth'
  config.gem 'liquid'
  
  config.gem 'fastercsv', :lib => 'faster_csv'
  config.gem 'cloudfiles'
  
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

# Mail Settings
# Mail Settings
ActionMailer::Base.default_url_options[:host] = "streetprint.org"
ActionMailer::Base.delivery_method = :smtp

 ActionMailer::Base.smtp_settings = {
    :tls => true,
    :address => "smtp.gmail.com",
    :port => "587",
    :domain => "streetprint.org",
    :authentication => :plain,
    :user_name => "noreply@streetprint.org",
    :password => "notachance"
  }
