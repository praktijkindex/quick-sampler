# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "quick/sampler/version"

Gem::Specification.new do |spec|
  spec.name          = "quick-sampler"
  spec.version       = Quick::Sampler::VERSION
  spec.authors       = ["Artem Baguinski"]
  spec.email         = ["abaguinski@depraktijkindex.nl"]
  spec.summary       = %q{Composable samplers of random data}
  spec.description   = %q{Describe randomness and watch it blend}
  spec.homepage      = "https://github.com/praktijkindex/quick-sampler"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "yard", "~> 0.8.7"
  spec.add_development_dependency "redcarpet", "~> 3.2"

  spec.add_runtime_dependency "activesupport", "~> 4.2"
end
