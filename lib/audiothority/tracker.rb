# encoding: utf-8

module Audiothority
  class Tracker
    def initialize
      @suspects = {}
    end

    def suspects
      @suspects.freeze
    end

    def mark(path, violations)
      @suspects[path] = violations
    end
  end
end
