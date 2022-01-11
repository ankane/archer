require_relative "lib/archer/version"

Gem::Specification.new do |spec|
  spec.name          = "archer-rails"
  spec.version       = Archer::VERSION
  spec.summary       = "Rails console history for Heroku, Docker, and more"
  spec.homepage      = "https://github.com/ankane/archer"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.6"

  spec.add_dependency "railties", ">= 5.2"
  spec.add_dependency "activerecord", ">= 5.2"
end
