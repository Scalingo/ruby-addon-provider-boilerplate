source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'

gem 'mongoid', '~> 6.1.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'bcrypt', '~> 3.1.7'

gem 'nsq-env', '~> 0.1.1'
gem 'mongoid_paranoia', '~> 0.3.0'

gem 'scalingo-provider_api', '~> 0.1'

gem 'uglifier', '~> 2.7'

# View
gem 'haml', '~> 5.0'
gem 'materialize-sass', '~> 0.100.2'
gem 'material_icons', '~> 2.2'
gem 'jquery-rails', '~> 4.3'

gem 'philae', '~> 0.2.7'
gem 'etcd-discovery', '~> 1.0', '>= 1.0.3'
gem 'rollbar', '~> 2.15', '>= 2.15.5'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'pry'
  gem 'rspec-rails'
  gem 'factory_girl'
  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rerun'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
