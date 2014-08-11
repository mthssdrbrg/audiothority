# encoding: utf-8

module Audiothority
  class Validation
    attr_reader :error

    def initialize(valid, error=nil)
      @valid = valid
      @error = error
    end

    def valid?
      !!@valid
    end

    def invalid?
      !valid?
    end
  end

  class UniqueValidator
    def initialize(thing)
      @thing = thing
    end

    def validate(tags)
      items = tags.map { |t| t.send(@thing) }.uniq
      if items.one?
        Validation.new(true)
      elsif items.empty?
        Validation.new(false, %(missing #{@thing.inspect}))
      elsif items.size > 1
        Validation.new(false, %(multiple #{@thing}s: #{items.map(&:inspect).join(', ')}))
      else
        Validation.new(false, %(unexpected result for #{@thing}: #{items.map(&:inspect).join(', ')}))
      end
    end
  end

  class AlbumValidator < UniqueValidator
    def initialize
      super(:album)
    end
  end

  class ArtistValidator < UniqueValidator
    def initialize
      super(:artist)
    end
  end

  class YearValidator < UniqueValidator
    def initialize
      super(:year)
    end
  end
end
