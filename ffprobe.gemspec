# -*- encoding: utf-8 -*-

require File.expand_path('../lib/ffprobe/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'ffprobe'
  gem.version     = FFProbe::VERSION.dup
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@seonic.net' ]
  gem.description = 'ffprobe wrappter'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/mbj/ffprobe'

  gem.require_paths    = [ 'lib' ]

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- spec`.split("\n")

  gem.extra_rdoc_files = %w(TODO)

  gem.add_runtime_dependency('backports',  '~> 2.6.1')
  gem.add_runtime_dependency('virtus',     '~> 0.5.1')
  gem.add_runtime_dependency('multi_json', '~> 1.3.6')

  gem.add_development_dependency('rake',        '~> 0.9.2')
  gem.add_development_dependency('rspec',       '~> 1.3.2')
  gem.add_development_dependency('guard-rspec', '~> 0.7.0')
end
