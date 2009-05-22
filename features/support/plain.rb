Cucumber::Rails.use_transactional_fixtures
Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling 
                              # (e.g. rescue_action_in_public / rescue_responses / rescue_from)


Cucumber::Rails.use_transactional_fixtures
Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling 
                              # (e.g. rescue_action_in_public / rescue_responses / rescue_from)

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

require 'cucumber/rails/rspec'
require 'webrat/core/matchers'


def empty_database
  connection = ActiveRecord::Base.connection
  connection.tables.each do |table|
    connection.execute "DELETE FROM #{table}"
  end
end

Before do
  empty_database
end

After do
  empty_database
end