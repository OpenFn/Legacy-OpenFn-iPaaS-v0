require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

# Avoids Ox as the default parser for the OdkAggregate gem.
# See issue [#62](https://github.com/OpenFn/OpenFn-Site/issues/62)
MultiXml.parser = :rexml

Faraday.default_adapter = :typhoeus

module OpenFn
  class Application < Rails::Application

    require 'to_bool'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.paths << "#{Rails.root}/app/assets/templates"

    config.active_record.observers = :user_observer
  end
end
