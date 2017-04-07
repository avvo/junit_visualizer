worker_processes ENV['WORKERS'].to_i
working_directory ENV.fetch('APP_HOME', '/srv/junit_visualizer/current')
listen '0.0.0.0:3000', :tcp_nopush => true
timeout 15
pid nil
preload_app true

GC.respond_to?(:copy_on_write_friendly=) and
    GC.copy_on_write_friendly = true

before_exec do |server|
  paths = (ENV["PATH"] || "").split(File::PATH_SEPARATOR)
  ENV["PATH"] = paths.uniq.join(File::PATH_SEPARATOR)
  ENV['BUNDLE_GEMFILE'] = ""
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!

  old_pid = '/var/run/junit_visualizer-unicorn.pid.oldbin'
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
