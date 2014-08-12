# encoding: utf-8

module Audiothority
  module Validators
    class Unique
      def initialize(thing)
        @thing = thing
      end

      def validate(tags)
        items = tags.map { |t| t.send(@thing) }.uniq
        if items.one?
          Validation.new
        elsif items.compact.empty?
          Violation.new(@thing, :missing, %(missing #{@thing} field))
        elsif items.size > 1
          Violation.new(@thing, :multiple, %(multiple #{@thing}s: #{items.map(&:inspect).join(', ')}))
        end
      end
    end
  end
end
