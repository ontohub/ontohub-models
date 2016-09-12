# frozen_string_literal: true

unless defined?(Coveralls)
  require 'simplecov'
  require 'coveralls'
  simplecov_settings = nil
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ]
  SimpleCov.start(simplecov_settings) do
    # This initializer is not executed because no migrations are run.
    add_filter 'config/initializers/expose_migrations_path.rb'
    # The version is only used in the gemspec.
    add_filter 'lib/ontohub_models/version.rb'
    # Ignore the dummy application that is used for the spec.
    add_filter 'spec/dummy'
  end
end
