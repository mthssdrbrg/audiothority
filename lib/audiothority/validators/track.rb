# encoding: utf-8

module Audiothority
  module Validators
    class TrackNumber
      def validate(tags)
        missing = tags.map(&:track).select(&:zero?)
        if missing.empty?
          Validation.new
        else
          Violation.new(:track, :missing, 'track(s) without track numbers', false)
        end
      end
    end
  end
end
