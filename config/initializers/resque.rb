Resque.redis = ENV['REDISCLOUD_URL'] unless ENV['REDISCLOUD_URL'].nil?
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
