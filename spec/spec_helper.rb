# encoding: utf-8

require 'tmpdir'
require 'ostruct'
require 'support/cli_setup'
require 'support/interactive'
require 'coveralls'
require 'simplecov'

if ENV.include?('TRAVIS')
  Coveralls.wear!
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end

SimpleCov.start do
  add_group 'Source', 'lib'
  add_group 'Unit tests', 'spec/audiothority'
  add_group 'Integration tests', 'spec/integration'
end

require 'audiothority'
