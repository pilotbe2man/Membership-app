ActionMailer::Base.smtp_settings = {
    :user_name => 'healthierchildcareapp',
    :password => 'asnf101275',
    :domain => 'tryggerehelsebevarendebarneomsorg.no',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.

  config.paperclip_defaults = {
  storage: :s3,
  s3_credentials: {
    bucket: Rails.application.secrets.aws_s3_bucket,
    access_key_id: Rails.application.secrets.s3_access_key,
    secret_access_key: Rails.application.secrets.s3_secret_key,
    s3_region: Rails.application.secrets.s3_region
  }
}

  config.cache_classes = false

  config.stripe.debug_js = true

  config.log_level = :info

  # Do not eager load code on boot.
  config.eager_load = false

  config.action_mailer.preview_path = "#{Rails.root}/app/mailers/previews"

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: 'localhost:3000',
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: Rails.application.secrets.email_provider_username,
    password: Rails.application.secrets.email_provider_password
  }
  # ActionMailer Config
  config.action_mailer.default_url_options = { :host => Rails.application.secrets.mailer_default_url }
  # config.action_mailer.asset_host = Rails.application.secrets.mailer_asset_host

  # config.action_mailer.delivery_method = :smtp
  

  config.action_mailer.delivery_method = :smtp


  config.action_mailer.raise_delivery_errors = false
  # Send email in development mode?
  config.action_mailer.perform_deliveries = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
