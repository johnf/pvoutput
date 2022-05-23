# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pvoutput/version'

Gem::Specification.new do |spec|
  spec.name          = 'pvoutput'
  spec.version       = PVOutput::VERSION
  spec.authors       = ['John Ferlito']
  spec.email         = ['johnf@inodes.org']

  spec.summary       = 'Library to speak to the PVOutput API'
  spec.homepage      = 'https://github.com/johnf/pvoutput'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.require_paths = ['lib']
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'httparty'

  spec.add_development_dependency 'bundler', '>= 2.1'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'webmock'
end
