# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'ontohub-models/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = 'ontohub-models'
  s.version       = OntohubModels::VERSION
  s.authors       = ['Ontohub Core Developers']
  s.email         = ['ontohub-dev-l@ovgu.de']
  s.summary       = 'Shared models for Ontohub'
  s.description   = 'Shared models for Ontohub'
  s.homepage      = 'https://github.com/ontohub/ontohub-models'
  s.license       = 'GNU AFFERO GPL'

  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|s|features)/})
  end
  s.test_files = Dir['spec/**/*']

  # Prevent pushing this gem to RubyGems.org.
  unless s.respond_to?(:metadata)
    raise "We don't want to publish this outside of the Ontohub project."
  end

  # Runtime dependencies
  s.add_dependency 'chewy', '>= 0.10.1', '< 5.1.0'
  s.add_dependency 'devise', '>= 4.3', '< 4.7'
  s.add_dependency 'rails', '>= 5.1.4', '< 5.3.0'
  s.add_dependency 'sequel', '>= 5.2', '< 5.34'
  s.add_dependency 'sequel-devise', '~> 0.0.11'
  s.add_dependency 'sequel-rails', '~> 1.0.0'
  s.add_dependency 'sequel_pg', '>= 1.8', '< 1.12'
  s.add_dependency 'sequel_postgresql_triggers', '>= 1.3', '< 1.6'

  # General Development
  s.add_development_dependency 'bundler', '~> 1.11'
  s.add_development_dependency 'rake', '~> 12.3.0'

  s.add_development_dependency 'pry-byebug', '~> 3.7.0'
  s.add_development_dependency 'pry-rescue', '~> 1.5.0'
  s.add_development_dependency 'pry-stack_explorer', '~> 0.4.9.2'

  # Testing
  s.add_development_dependency 'database_cleaner', '~> 1.7.0'
  s.add_development_dependency 'factory_bot_rails', '~> 4.10.0'
  s.add_development_dependency 'faker', '~> 1.9.1'
  s.add_development_dependency 'fuubar', '~> 2.3.0'
  s.add_development_dependency 'rspec', '~> 3.7.0'
  s.add_development_dependency 'rspec-rails', '~> 3.7.2'

  # CI services
  s.add_development_dependency 'rubocop', '~> 0.65.0'

  # We want to have these in the production environment as well in case we need
  # to debug the application:
  s.add_dependency 'awesome_print', '~> 1.8.0'
  s.add_dependency 'pry', '>= 0.11', '< 0.13'
end
