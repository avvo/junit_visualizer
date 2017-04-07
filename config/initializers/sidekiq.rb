redis_config = Rails.application.config_for(:redis)

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Redis.current = Sidekiq.redis {|c| c}
