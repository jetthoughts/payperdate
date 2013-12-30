unless %w(development test).include? Rails.env
  Sidekiq.redis do |redis|
    options = {cache: redis, cache_prefix: 'geocoder', lookup: :google}
    Geocoder.configure options
  end
end
