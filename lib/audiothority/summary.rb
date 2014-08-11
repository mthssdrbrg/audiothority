# encoding: utf-8

module Audiothority
  class Summary
    def initialize(stats)
      @stats = stats
    end

    def display(console)
      if (invalid = @stats.invalid) && invalid.any?
        invalid.each do |path, violations|
          console.say %(#{path} is inconsistent due to:)
          violations.each do |violation|
            checkmark = console.set_color(%(  ✗ ), :red, :bold)
            console.say(checkmark + violation.error)
          end
        end
      else
        checkmark = console.set_color(%(  ✓ ), :green, :bold)
        console.say(checkmark + %(All is good))
      end
    end
  end
end
