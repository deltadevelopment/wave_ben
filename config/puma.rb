workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.establish_connection

  if defined?(Resque)
    Resque.redis = ENV["REDISCLOUD_URL"] || "redis://127.0.0.1:6379"
  end
end
