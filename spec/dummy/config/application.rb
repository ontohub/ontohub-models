require_relative 'boot'

# Pick the frameworks you want:
require 'active_model/railtie'
# require 'active_job/railtie'
# require 'active_record/railtie'
# require 'action_controller/railtie'
# require 'action_mailer/railtie'
# require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)
require 'ontohub-models'

module Dummy
  class Application < Rails::Application
    # Do not dump the schema in the dummy application.
    config.sequel.schema_dump = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Sequel 5 and sequel-rails always try connect to the database, even if it
    # does not exist AND it should be created by the currently running rake
    # task. This is a workaround:
    tasks_without_connection = %w(db:drop db:create db:recreate)
    config.sequel.skip_connect =
      defined?(Rake) &&
      (Rake.application.top_level_tasks & tasks_without_connection).any?
  end
end
