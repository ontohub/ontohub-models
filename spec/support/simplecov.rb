# frozen_string_literal: true

if RUBY_ENGINE == 'ruby' # not 'rbx'
  unless defined?(SimpleCov)
    require 'simplecov'
    SimpleCov.start do
      # This initializer is not executed because no migrations are run.
      add_filter 'config/initializers/expose_migrations_path.rb'
      # The version is only used in the gemspec.
      add_filter 'lib/ontohub-models/version.rb'
      # Ignore the dummy application that is used for the spec.
      add_filter 'spec/dummy'
      # Ignore the RSpec configuration files.
      add_filter 'spec/spec_helper.rb'
      add_filter 'spec/rails_helper.rb'
    end
    require 'codecov'
    formatters = [SimpleCov::Formatter::HTMLFormatter]
    formatters << SimpleCov::Formatter::Codecov if ENV['CI']
    SimpleCov.formatters = formatters
  end
end
