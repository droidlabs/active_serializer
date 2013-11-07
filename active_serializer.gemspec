# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_serializer/version'

Gem::Specification.new do |spec|
  spec.name          = "active_serializer"
  spec.version       = ActiveSerializer::VERSION
  spec.authors       = ["Albert Gazizov", "Ruslan Gatiyatov"]
  spec.email         = ["deeper4k@gmail.com", "ruslan.gatiyatov@gmail.com"]
  spec.description   = %q{Object to Hash serializer}
  spec.summary       = %q{Adds simple DSL to convert ruby objects to hash}
  spec.homepage      = "http://github.com/droidlabs/active_serializer"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activesupport"
end
