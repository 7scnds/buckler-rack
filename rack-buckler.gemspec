# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/buckler/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-buckler"
  spec.version       = Rack::Buckler::VERSION
  spec.authors       = ["Sega Okhiria"]
  spec.email         = ["sega.okhiria@7scnds.com"]
  spec.description   = %q{Middleware that will make Rack-based apps communicate with buckler client. Read more here: '{location to buckler and rack here}'.}
  spec.summary       = %q{Middleware for communicating buckler client in Rack apps}
  spec.homepage      = "https://bitbucket.org/segaokhiria/rack-buckler"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).reject { |f| f == '.gitignore' or f =~ /^examples/ }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
=begin
  spec.add_development_dependency "minitest", ">= 5.3.0"
  spec.add_development_dependency "mocha", ">= 0.14.0"
  spec.add_development_dependency "rack-test", ">= 0"
=end
end
