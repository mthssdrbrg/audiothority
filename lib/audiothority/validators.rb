# encoding: utf-8

module Audiothority
  module Validators
    def self.default
      [Artist, Album, TrackNumber, Year].map(&:new)
    end
  end
end

require 'audiothority/validators/unique'
require 'audiothority/validators/album'
require 'audiothority/validators/artist'
require 'audiothority/validators/track'
require 'audiothority/validators/year'
