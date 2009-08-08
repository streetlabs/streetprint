require 'cucumber/rake/task'
require 'spec/rake/spectask'
 
namespace :rcov do
  begin
     require 'cucumber/rake/task'
  
     Cucumber::Rake::Task.new(:features) do |t|
       t.fork = true
       t.profile = 'default'
       t.rcov = true
       t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/,features_selenium\/}
       t.rcov_opts << %[-o "coverage"]
     end
     task :features => 'db:test:prepare'
   rescue LoadError
     desc 'Cucumber rake task not available'
     task :features do
       abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
     end
   end
   
  begin
    require 'cucumber/rake/task'

    Cucumber::Rake::Task.new(:selenium) do |t|
      t.fork = true
      t.profile = 'selenium'
      t.rcov = true
      t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/,features_selenium\/ }
      t.rcov_opts << %[-o "coverage"]
    end
    task :selenium => 'db:test:prepare'
  rescue LoadError
    desc 'Cucumber rake task not available'
    task :selenium do
      abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
    end
  end
  
  Spec::Rake::SpecTask.new(:rspec) do |t|
    t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = lambda do
      IO.readlines("#{RAILS_ROOT}/spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
    end
  end
  
  desc "Run all but selenium tests and generate aggregated coverage"
  task :integrity do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    Rake::Task["rcov:features"].invoke
    Rake::Task["rcov:rspec"].invoke
    rm "coverage.data" if File.exist?("coverage.data")
  end
  
  desc "Run both specs and features to generate aggregated coverage"
  task :all do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    Rake::Task["rcov:selenium"].invoke
    Rake::Task["rcov:features"].invoke
    Rake::Task["rcov:rspec"].invoke
    rm "coverage.data" if File.exist?("coverage.data")
  end
end
