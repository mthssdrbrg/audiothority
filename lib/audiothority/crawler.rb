# encoding: utf-8

module Audiothority
  class Crawler
    def initialize(dirs, blacklist=[])
      @dirs = dirs
      @blacklist = blacklist
    end

    def crawl
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
      path.readable? && path.directory? && path.children.any? && !blacklisted?(path)
    end

    def blacklisted?(path)
      @blacklist.any? { |r| path.basename.to_s.match(r) }
    end
  end
end
