# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/download_hockey_ipa/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-download_hockey_ipa'
  spec.version       = Fastlane::DownloadHockeyIpa::VERSION
  spec.author        = 'horimislime'
  spec.email         = 'horimislime@gmail.com'

  spec.summary       = 'A fastlane plugin that helps downloading .ipa from HockeyApp'
  spec.homepage      = "https://github.com/horimislime/fastlane-plugin-download_hockey_ipa"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  spec.add_dependency 'faraday', '~> 0.12.1'
  spec.add_dependency 'faraday_middleware', '~> 0.11.0.1'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 2.46.0'
end
