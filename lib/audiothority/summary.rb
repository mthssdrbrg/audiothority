# encoding: utf-8

module Audiothority
  class Summary
    def initialize(stats)
      @stats = stats
    end

    def display(io)
      if (invalid = @stats.invalid) && invalid.any?
        invalid.each do |path, violations|
          io.puts %(#{path} is inconsistent due to:)
          violations.each do |violation|
            io.puts %(  ✗ #{violation.error})
          end
        end
      else
        io.puts %(  ✓ All is good, no invalid albums found)
      end
    end
  end
end
