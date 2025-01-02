# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.4'

gem 'rails', '~> 7.0.8', '>= 7.0.8.6'

gem 'blueprinter', '~> 1.1', '>= 1.1.2'
gem 'bootsnap', require: false
gem 'devise', '~> 4.9'
gem 'importmap-rails'
gem 'pagy', '~> 9.3'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails', '~> 2.0', '>= 2.0.32'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 3.1', '>= 3.1.4'
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.4'
  gem 'faker', '~> 3.5', '>= 3.5.1'
  gem 'rspec-rails', '~> 7.0', '>= 7.0.1'
  gem 'rubocop', '~> 1.68'
  gem 'rubocop-rails', '~> 2.27'
  gem 'shoulda-matchers', '~> 6.4'
end

group :development do
  gem 'letter_opener', '~> 1.10'
  gem 'web-console'
end
