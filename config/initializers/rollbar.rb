require 'rollbar/rails'
Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_TOKEN']

  config.enabled = false if Rails.env.test? || Rails.env.development?
end
