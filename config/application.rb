require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ScalingoAddonBoilerplateRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    config.logger = Logger.new(STDERR)

    prober = Philae::Prober.new
    prober.add_probe Philae::NSQProbe.new 'nsq', ENV['NSQD_HOST']
    mongo_url = ENV.fetch('MONGO_URL', "mongodb://#{ENV['MONGO_HOST']}")
    prober.add_probe Philae::MongoProbe.new 'mongo', mongo_url
    config.middleware.use Rack::Philae, prober
  end
end
