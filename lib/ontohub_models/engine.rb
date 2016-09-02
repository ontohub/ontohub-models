require 'pry'
require 'sequel-rails'

module OntohubModels
  class Engine < ::Rails::Engine
    config.generators.api_only = true

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories',
                                           suffix: 'factory'
    end
  end
end
