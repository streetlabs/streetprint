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
require 'cucumber/rails/rspec'
require 'ruby-debug'
require 'cucumber_rails_debug/steps'

Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling 
                              # (e.g. rescue_action_in_public / rescue_responses / rescue_from)

Webrat.configure do |config|
  config.mode = :rails
end


ts = ThinkingSphinx::Configuration.instance
ts.build
FileUtils.mkdir_p ts.searchd_file_path
ts.controller.index
ts.controller.start
at_exit do
  ts.controller.stop
end
ThinkingSphinx.deltas_enabled = true
ThinkingSphinx.updates_enabled = true
ThinkingSphinx.suppress_delta_output = true

$static_tables = [
"site_themes",
"layout_templates",
"show_site_templates",
"show_about_templates",
"show_news_posts_templates",
"show_artifact_templates",
"browse_artifacts_templates",
"index_artifacts_templates",
"show_author_templates",
"show_full_text_templates",
"show_google_location_templates"
]


def empty_database(static_tables = [])
  connection = ActiveRecord::Base.connection
  connection.tables.each do |table|
    next if static_tables.include?(table)
    connection.execute "DELETE FROM #{table}"
  end
end

Before do
  empty_database()
  load_seed_data
  ts.controller.index
end

After do
end

empty_database
# load seed data
def load_seed_data
  Dir[File.join(RAILS_ROOT, "db/fixtures", '*.rb')].sort.each { |fixture| load fixture }
end
load_seed_data
