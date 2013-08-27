REDIS_CONFIG = {:url => 'redis://localhost:6379', :namespace => 'mp'}
Sidekiq.configure_server { |config| config.redis = REDIS_CONFIG }
Sidekiq.configure_client { |config| config.redis = REDIS_CONFIG }