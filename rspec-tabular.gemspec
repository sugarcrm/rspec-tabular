# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/tabular/version'

Gem::Specification.new do |spec|
  spec.name          = 'rspec-tabular'
  spec.version       = Rspec::Tabular::VERSION
  spec.authors       = ['Andrew Sullivan Cant']
  spec.email         = ['acant@sugarcrm.com']

  spec.summary       = %q{RSpec extension for writing tabular examples.}
  spec.description   = %q{RSpec DSL which makes is easier and cleaner to write tabular examples.}
  spec.homepage      = 'http://github.com/sugarcrm/rspec-tabular'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake',    '~> 10.0'
end