source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'pg'
gem 'thin'
gem 'jquery-rails'
gem 'haml'

group :development do
  gem 'rspec-rails'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
end

group :test do
  gem 'rspec'
  gem 'webrat'
  gem 'spork', '~> 0.9.0.rc'
  gem 'factory_girl_rails'
end

group :production do
  # gems specifically for Heroku go here
  # gem 'pg'
end

group :assets do
  gem 'uglifier'
end