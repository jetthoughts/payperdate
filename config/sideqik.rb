uri   = URI.parse(Settings.redis.url)
redis_attrs = { url: uri, namespace: 'background' }
Sidekiq.configure_server do |config|
  config.redis = redis_attrs
end
Sidekiq.configure_client do |config|
  config.redis = redis_attrs
end