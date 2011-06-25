# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "confetti/version"

Gem::Specification.new do |s|
  s.name        = "confetti"
  s.version     = Confetti::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrew Lunny"]
  s.email       = ["alunny@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/confetti"
  s.summary     = %q{Generate mobile app config files}
  s.description = %q{ A little library to generate platform-specific mobile app
                      configuration files from a W3C widget spec compliant config.xml}

  s.rubyforge_project = "confetti"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "mustache", "~> 0.11.2"
  s.add_dependency "thor", "~> 0.14.3"

  s.add_development_dependency "rspec", "~> 2.1.0"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "aruba"
end
