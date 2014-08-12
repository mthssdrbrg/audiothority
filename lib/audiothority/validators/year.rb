# encoding: utf-8

module Audiothority
  module Validators
    class Year < Unique
      def initialize
        super(:year)
      end
    end
  end
end
