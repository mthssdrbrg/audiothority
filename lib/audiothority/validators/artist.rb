# encoding: utf-8

module Audiothority
  module Validators
    class Artist < Unique
      def initialize
        super(:artist)
      end
    end
  end
end
