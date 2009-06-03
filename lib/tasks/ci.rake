namespace :ci do
  begin
    desc 'Create a link to the metrics website from the current metrics'
    task :report => ['metrics:all'] do
      rcov_dir = File.join(File.dirname(__FILE__), "../../tmp/metric_fu/output/")
      system("rm -rf /var/metrics/streetprint")
      system("mv #{rcov_dir} /var/metrics/streetprint")
      system("chown -R _www /var/metrics/streetprint")
    end
  rescue LoadError
    desc 'Could not create report directory'
    task :report do
      abort 'Report was not created'
    end
  end
end
