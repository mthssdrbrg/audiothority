# encoding: utf-8

module Audiothority
  class Validation
    def initialize(valid=true)
      @valid = valid
    end

    def valid?
      !!@valid
    end

    def invalid?
      !valid?
    end
  end

  class Violation < Validation
    attr_reader :field, :reason, :message

    def initialize(field, reason, message, applicable=true)
      super(false)
      @field = field
      @reason = reason
      @message = message
      @applicable = applicable
    end

    def applicable?
      !!@applicable
    end
  end
end
