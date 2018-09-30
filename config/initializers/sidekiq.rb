require 'sidekiq'
require 'sidekiq-status'

if Rails.env.development?
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://localhost:6379/12' }
      config.server_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
      end
      config.client_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
      end
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:6379/12' }
      config.client_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
      end      
    end
elsif Rails.env.production?
    Sidekiq.configure_server do |config|
      config.redis = { url: ENV['REDIS_URL'] }
      config.server_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
      end
      config.client_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
      end
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: ENV['REDIS_URL'] }
      config.client_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
      end      
    end
end