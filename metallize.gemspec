# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metallize/version'

Gem::Specification.new do |spec|
  spec.name          = "metallize"
  spec.version       = Metallize::VERSION
  spec.authors       = ["Sam Treweek"]
  spec.email         = ["samtreweek@gmail.com"]
  spec.summary       = %q{Mechanize plus Selenium}
  spec.description   = %q{Mechanize API with Selenium-WebDriver Library}
  spec.homepage      = "http://uksa.eu"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'rspec', '~> 3.4', '>= 3.4.0'
  spec.add_runtime_dependency 'selenium-webdriver', '~> 2.48', '>= 2.48.1'
  spec.add_runtime_dependency 'mechanize'
end
