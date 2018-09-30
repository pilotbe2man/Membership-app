source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.6'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'haml-rails'
gem 'foreman'

# Performance
gem 'fast_blank'
gem 'jquery-turbolinks'
gem 'turbolinks'

gem 'devise'
gem 'sitemap_generator'
gem 'unicorn', platforms: :ruby
gem 'pg'
gem 'countries_and_languages', :require => 'countries_and_languages/rails'
gem 'newrelic_rpm'

# Web Services
gem 'sendinblue'
gem 'survey-gizmo-ruby'

# HTTP Party
gem 'httparty'

# Localization
gem 'i18n-active_record', :require => 'i18n/active_record'

# Currency List
gem 'currency_select'
gem 'currencies', :require => 'iso4217'

gem "select2-rails"

group :production do
  gem 'unicorn-worker-killer'
  gem 'lograge'
  # heroku
  gem 'rails_12factor'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'
  # gem 'rack-mini-profiler'
  gem 'capistrano', '~> 2.15'
  gem 'bullet'
  gem 'capistrano-unicorn', require: false, platforms: :ruby
  gem 'thin'
  gem 'colorize'
  gem 'annotate'
  gem 'spring'
end

gem "letter_opener", :group => :development
group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1' 
  gem 'email_spec'
  gem 'fuubar'
  gem 'rspec-timecop'
  gem 'simplecov'
  gem 'fake_stripe'
  gem "codeclimate-test-reporter", "~> 1.0.0"
end

group :development, :test do
  gem 'rspec-rails'
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
  # gem 'dotenv'
  gem 'dotenv-rails'
end

gem 'compass-rails'
gem 'rollbar'
gem 'whenever', require: false

gem 'gibbon'

# payment processor
gem 'stripe'
gem 'stripe-rails'

# image processing
gem 'mini_magick'
gem 'carrierwave'
gem 'copy_carrierwave_file'
gem 'paperclip'
gem 'aws-sdk', '~> 2.3'

# background processing
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidekiq-status'
gem 'active_job_status'
gem 'redis-store'
gem 'redis-activesupport'
gem 'sinatra', :require => nil

# fake data
gem 'faker'

# surveys
gem "survey", "~> 0.1"

# date
gem 'jquery-datetimepicker-rails'

# Pagination
gem 'kaminari'

# Time
gem 'chronic'

# spreadsheet
gem 'roo'
gem 'roo-xls'

# Word docx
gem 'docx'

# wysiwyg
gem 'wysiwyg-rails'

gem 'ckeditor'

# frontend
gem 'simple_form'
gem 'simple_form_extension'
gem 'redactor-rails', github: 'glyph-fr/redactor-rails'
gem 'exception_handler'
