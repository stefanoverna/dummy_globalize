# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dummy_globalize/version'

Gem::Specification.new do |spec|
  spec.name          = "dummy_globalize"
  spec.version       = DummyGlobalize::VERSION
  spec.authors       = ["Stefano Verna"]
  spec.email         = ["s.verna@cantierecreativo.net"]
  spec.summary       = %q{Because I must be too stupid to understand globalize.}
  spec.description   = %q{Because I must be too stupid to understand globalize.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'activerecord', ['>= 3.2', '< 4.3']
  spec.add_dependency 'activesupport'
end
