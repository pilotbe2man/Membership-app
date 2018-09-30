require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HealthChildcare
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Timezone
    config.time_zone = ENV['TIMEZONE']
    config.active_record.default_timezone = :local

    config.assets.initialize_on_precompile = false

    config.autoload_paths += %w(#{config.root}/app/models/ckeditor)
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.autoload_paths << Rails.root.join('lib')

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    config.exception_handler = {
      email: "kontakt@friskereogtryggerebarneomsorg.no"
    }

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
        g.test_framework :rspec,
            fixtures: true,
            view_specs: false,
            helper_specs: true,
            routing_specs: false,
            controller_specs: true,
            feature_specs: true
        g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    #config.asset_host = 'http://localhost:3000'

    #Survey Gizmo Configuration
    # Version of your assets, change this if you want to expire all your assets
      config.assets.version = '1.0'
      config.before_configuration do
        env_file = File.join(Rails.root, 'config', 'local_env.yml')
        YAML.load(File.open(env_file)).each do |key, value|
          ENV[key.to_s] = value
        end if File.exists?(env_file)
      end

    SurveyGizmo.configure
  end
end
