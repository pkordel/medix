source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"

gem "rails", "~> 7.0.2", ">= 7.0.2.3"

gem "sprockets-rails"

gem "pg", "~> 1.1"

gem "puma", "~> 5.0"

gem "importmap-rails"

gem "turbo-rails"

gem "stimulus-rails"

gem "tailwindcss-rails"

gem "redis", "~> 4.0"
gem "cable_ready", "5.0.0.pre9"
gem "hiredis"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry"
  gem "pry-stack_explorer"
  gem "ruby_jard"
  gem "awesome_print"
  gem "faker"
  gem "rspec-rails"
  gem "standard", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem "letter_opener"
end

group :test do
  gem "capybara"
  gem "capybara-email"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "database_cleaner"
  gem "factory_bot_rails"
end

group "production" do
  gem "rails_autoscale_agent"

  # Use S3 for Active Storage by default.
  gem "aws-sdk-s3", require: false
end

gem "devise"
gem "rack-cors"
gem "sidekiq"
gem "cancancan"
gem "fastimage"
gem "active_hash", github: "bullet-train-co/active_hash"
gem "bullet_train-roles"
