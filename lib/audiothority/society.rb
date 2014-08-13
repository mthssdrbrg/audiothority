# encoding: utf-8

module Audiothority
  class EmptySociety
    def transfer(*args) ; end
  end

  class Society
    def initialize(location, fileutils=FileUtils)
      @location = Pathname.new(location)
      @fileutils = fileutils
    end

    def transfer(enforced)
      @fileutils.move(enforced, @location)
    end
  end
end
