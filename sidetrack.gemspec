$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sidetrack/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sidetrack"
  s.version     = Sidetrack::VERSION
  s.authors     = ["Jonathan Greenberg"]
  s.email       = ["jonathan.s.greenberg@gmail.com"]
  s.homepage    = ""
  s.summary     = "Tracks model status with polymorphic timestamp fields"
  s.description = <<-EOS
  Rather than clutter your models with ever changing status timestamp fields,
Sidetrack allows you to easily track when and who changed a model in a separate
table using polymorphic associations.
  EOS
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails", "~> 3.7.2"
end
