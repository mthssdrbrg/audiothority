# encoding: utf-8

module Audiothority
  class Summary
    def initialize(state)
      @state = state
    end

    def display(console)
      if @state.any?
        @state.each do |path, violations|
          console.say %(#{path} is inconsistent due to:)
          violations.each do |violation|
            checkmark = console.set_color(%(  ✗ ), :red, :bold)
            console.say(checkmark + violation.message)
          end
        end
      else
        checkmark = console.set_color(%(  ✓ ), :green, :bold)
        console.say(checkmark + %(All is good))
      end
    end
  end

  class PathsOnlySummary < Summary
    def display(console)
      @state.each do |path, _|
        console.say(File.expand_path(path))
      end
    end
  end
end
