$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "shiny_themes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "shiny_themes"
  s.version     = ShinyThemes::VERSION
  s.authors     = ["shinylane"]
  s.email       = ["roblane09@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "A simple Rails theme plugin"
  s.description = "Generate and manage themes which are made up of templates and assets."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.1"
end
