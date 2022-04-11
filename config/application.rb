require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Medix
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Stockholm"
    config.eager_load_paths << Rails.root.join("lib")

    # Don't generate system test files.
    config.generators.system_tests = nil

    def default_url_options_from_base_url
      if ENV["BASE_URL"].blank?
        if Rails.env.development?
          ENV["BASE_URL"] ||= "http://localhost:3000"
        else
          raise "you need to define the value of ENV['BASE_URL'] in your environment. if you're on heroku, you can do this with `heroku config:add BASE_URL=https://your-app-name.herokuapp.com` (or whatever your configured domain is)."
        end
      end

      parsed_base_url = URI.parse(ENV["BASE_URL"])
      default_url_options = [:user, :password, :host, :port].index_with { |key| [key, parsed_base_url.send(key)] }

      # the name of this property doesn't match up.
      default_url_options[:protocol] = parsed_base_url.scheme

      default_url_options.compact
    end
  end
end
