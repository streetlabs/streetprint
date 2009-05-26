namespace :test do
  begin
    require 'cucumber/rake/task'

    Cucumber::Rake::Task.new(:features) do |t|
      t.fork = true
      t.profile = 'default'
    end
    task :features => 'db:test:prepare'

    Cucumber::Rake::Task.new(:selenium) do |t|
      t.fork = true
      t.profile = 'selenium'
    end
    task :selenium => 'db:test:prepare'

  rescue LoadError
    desc 'Cucumber rake task not available'
    task :features do
      abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
    end
    task :selenium => [:features]
  end
  
  desc "Run specs"
  task :specs => [:spec]
  
  desc "Run all tests"
  task :all => [:spec, :features, :selenium]
end