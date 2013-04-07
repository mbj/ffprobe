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

  gem.add_runtime_dependency('backports',  '~> 3.3.0')
  gem.add_runtime_dependency('virtus',     '~> 0.5.2')
  gem.add_runtime_dependency('multi_json', '~> 1.7.2')
end
