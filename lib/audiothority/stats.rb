# encoding: utf-8

module Audiothority
  class Stats
    def initialize
      @invalid = {}
      @valid = []
    end

    def invalid
      @invalid.freeze
    end

    def mark_invalid(path, violations)
      @invalid[path] = violations
    end

    def mark_valid(path)
      @valid << path
    end
  end
end
