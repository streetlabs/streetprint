# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require File.expand_path(File.dirname(__FILE__) + '/../../features/factories')
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support
require 'webrat'
require 'webrat/rails'
require 'webrat/core/matchers'
require 'email_spec/cucumber'
require 'webrat/selenium'
require 'cucumber/rails/rspec'

Webrat.configure do |config|
  config.mode = :selenium
end

# this is necessary to have webrat "wait_for" the response body to be available
# when writing steps that match against the response body returned by selenium
World(Webrat::Selenium::Matchers)

def empty_database
  connection = ActiveRecord::Base.connection
  connection.tables.each do |table|
    connection.execute "DELETE FROM #{table}"
  end
end

Before do
  empty_database
  selenium.delete_all_visible_cookies
end

After do
  empty_database
end