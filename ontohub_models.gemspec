$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ontohub_models/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ontohub_models"
  s.version     = OntohubModels::VERSION
  s.authors     = ["Eugen Kuksa"]
  s.email       = ["kuksa.eugen@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of OntohubModels."
  s.description = "TODO: Description of OntohubModels."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"
end
