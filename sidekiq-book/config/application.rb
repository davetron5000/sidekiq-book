require_relative "boot"

# See https://github.com/rails/rails/blob/v7.0.4.2/railties/lib/rails/all.rb
# for the list of what rails/all requires
require "rails"

# This list is here as documentation only - it's not used
omitted = %w(
  active_storage/engine
  action_cable/engine
  action_mailbox/engine
  action_text/engine
)

# Only the frameworks in Rails that do not pollute our routes
%w(
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  rails/test_unit/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SidekiqBook
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_record.schema_format = :sql
  end
end
