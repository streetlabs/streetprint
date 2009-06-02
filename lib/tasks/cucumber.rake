$LOAD_PATH.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib') if File.directory?(RAILS_ROOT + '/vendor/plugins/cucumber/lib')

begin
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:features) do |t|
    t.fork = true
    t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'pretty')]
  end
  task :features => 'db:test:prepare'
  
  Cucumber::Rake::Task.new(:selenium) do |t|
    t.fork = true
    t.profile = "selenium"
  end
  task :selenium => 'db:test:prepare'
  
  
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
