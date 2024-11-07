source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.4"

gem "rails", "~> 7.0.8", ">= 7.0.8.6"
gem "bootsnap", require: false
gem "devise", "~> 4.9"
gem "importmap-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'faker', '~> 3.5', '>= 3.5.1'
  gem 'rspec-rails', '~> 7.0', '>= 7.0.1'
end

group :development do
  gem "web-console"
end
