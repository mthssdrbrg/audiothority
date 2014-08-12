# encoding: utf-8

module Audiothority
  class Crawler
    def initialize(dirs)
      @dirs = dirs
    end

    def each_crawled
      @dirs.each do |dir|
        dir.each_child do |path|
          if consider?(path)
            yield path
          end
        end
      end
    end

    private

    def consider?(path)
      path.readable? && path.directory? && path.children.any? && !ignore?(path)
    end

    def ignore?(path)
      blacklist.any? { |r| path.basename.to_s.match(r) }
    end

    def blacklist
      @blacklist ||= [
        /Various.Artists/i,
        /\/VA/,
        /OST/,
        /Original.Soundtrack/i,
        /Singles/
      ].freeze
    end
  end
end
