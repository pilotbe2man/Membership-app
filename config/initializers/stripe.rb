Rails.application.config.stripe.secret_key = Rails.application.secrets.stripe_secret_key
Rails.application.config.stripe.publishable_key = Rails.application.secrets.stripe_public_key

Stripe.api_key = Rails.configuration.stripe.secret_key