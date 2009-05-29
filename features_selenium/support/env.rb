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

require 'ruby-debug'

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

def remove_photos
  FileUtils.rm_r "#{RAILS_ROOT}/public/system/photos/test" if File.exist?("#{RAILS_ROOT}/public/system/photos/test")
end

Before do
  empty_database
  selenium.delete_all_visible_cookies
  remove_photos
end

After do
  empty_database
end