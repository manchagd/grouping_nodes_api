# frozen_string_literal: true

source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "blueprinter", "~> 1.1", ">= 1.1.2"
gem "rack-cors"
gem 'enumerate_it'
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "dotenv", "~> 3.1", ">= 3.1.7"
  gem "faker"
  gem "rubocop", require: false
  gem "annotate"
end

group :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "simplecov", require: false
  gem "shoulda-matchers", "~> 6.0"
end

gem "will_paginate", "~> 3.3"
