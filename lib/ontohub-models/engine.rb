# frozen_string_literal: true

require 'pry'
require 'sequel-rails'
require 'orm_adapter-sequel'
require 'devise'

module OntohubModels
  # The base engine class - Rails default
  class Engine < ::Rails::Engine
    config.generators.api_only = true

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories',
                                          suffix: 'factory'
    end
    config.sequel.after_connect = proc do
      begin
        Sequel::Model.db.extension :pg_enum
      # rubocop:disable HandleExceptions
      rescue Sequel::DatabaseConnectionError
        # If we are in rake db:create, we don't want the extension to be loaded.
        # See https://github.com/TalentBox/sequel-rails/issues/102
      end
    end
  end
end
