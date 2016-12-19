# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'ontohub_models/version'

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
  s.add_dependency 'rails', '~> 5.0.0', '>= 5.0.0.1'
  s.add_dependency 'sequel', '~> 4.41.0'
  s.add_dependency 'sequel_pg', '~> 1.6.17'
  s.add_dependency 'sequel-rails', '~> 0.9.14'
  s.add_dependency 'chewy', '~> 0.8.4'
  s.add_dependency 'devise', '~> 4.2.0'
  s.add_dependency 'sequel-devise', '~> 0.0.9'

  # General Development
  s.add_development_dependency 'bundler', '~> 1.12'
  s.add_development_dependency 'rake', '~> 12.0.0'

  # Testing
  s.add_development_dependency 'rspec', '~> 3.5.0'
  s.add_development_dependency 'rspec-rails', '~> 3.5.2'
  s.add_development_dependency 'rspec_sequel_matchers', '~> 0.4.0'
  s.add_development_dependency 'database_cleaner', '~> 1.5.3'
  s.add_development_dependency 'factory_girl_rails', '~> 4.8.0'
  s.add_development_dependency 'faker', '~> 1.6.6'

  # CI services
  s.add_development_dependency 'coveralls', '~> 0.8.17'

  # We want to have these in the production environment as well in case we need
  # to debug the application:
  s.add_dependency 'pry', '~> 0.10.4'
  s.add_dependency 'pry-rescue', '~> 1.4.4'
  s.add_dependency 'pry-stack_explorer', '~> 0.4.9.2'
  s.add_dependency 'pry-byebug', '~> 3.4.2'
  s.add_dependency 'awesome_print', '~> 1.7.0'
end
