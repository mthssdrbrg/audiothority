# encoding: utf-8

module Audiothority
  class UniqueValidator
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

  class TrackNumberValidator
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
