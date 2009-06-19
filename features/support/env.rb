# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require File.expand_path(File.dirname(__FILE__) + '/../factories')
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support
require 'webrat'
require 'webrat/rails'
require 'webrat/core/matchers'
require 'email_spec/cucumber'
require 'cucumber/rails/rspec'
require 'ruby-debug'

Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling 
                              # (e.g. rescue_action_in_public / rescue_responses / rescue_from)

Webrat.configure do |config|
  config.mode = :rails
end

ThinkingSphinx::Configuration.instance.build
ThinkingSphinx::Configuration.instance.controller.start
at_exit do
  ThinkingSphinx::Configuration.instance.controller.stop
end
ThinkingSphinx.deltas_enabled = true
ThinkingSphinx.updates_enabled = true
ThinkingSphinx.suppress_delta_output = true

@static_tables = ['roles']

def empty_database
  connection = ActiveRecord::Base.connection
  connection.tables.each do |table|
    connection.execute "DELETE FROM #{table}"
  end
end

def load_seed_data
  Dir[File.join(RAILS_ROOT, "db/fixtures", '*.rb')].sort.each { |fixture| load fixture }
end

Before do
  empty_database
  load_seed_data
end

After do
  empty_database
end

Before('@thinking_sphinx') do
  ThinkingSphinx::Configuration.instance.controller.index
end