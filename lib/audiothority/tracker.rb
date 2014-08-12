# encoding: utf-8

module Audiothority
  class Tracker
    def initialize
      @state = {}
    end

    def state
      @state.freeze
    end

    def mark(path, violations)
      @state[path] = violations
    end
  end
end
