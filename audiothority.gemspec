# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)

require 'audiothority/version'


Gem::Specification.new do |s|
  s.name        = 'audiothority'
  s.version     = Audiothority::VERSION
  s.author      = 'Mathias Söderberg'
  s.email       = 'mths@sdrbrg.se'
  s.homepage    = 'https://github.com/mthssdrbrg/audiothority'
  s.summary     = 'Find and organize inconsistencies in your music collection'
  s.description = 'Small utility for finding inconsistencies among audio files organized in "album" directories'
  s.license     = 'MIT'

  s.files         = Dir['lib/**/*.rb', 'README.md', 'LICENSE']
  s.test_files    = Dir['spec/**/*.rb']
  s.require_paths = %w[lib]
  s.executables << 'audiothorian'

  s.add_dependency 'taglib-ruby', '~> 0.6'
  s.add_dependency 'thor', '~> 0.19'

  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'
end
