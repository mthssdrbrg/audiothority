# encoding: utf-8

module Audiothority
  module Validators
    class Album < Unique
      def initialize
        super(:album)
      end
    end
  end
end
