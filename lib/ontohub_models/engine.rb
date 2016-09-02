require 'sequel-rails'

module OntohubModels
  class Engine < ::Rails::Engine
    config.generators.api_only = true
  end
end
