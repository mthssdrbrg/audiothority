# encoding: utf-8

module Audiothority
  class Crawler
    def initialize(dirs)
      @dirs = dirs
    end

    def each_crawled
      @dirs.each do |dir|
        dir.each_child do |path|
          if path.readable? && path.directory? && path.children.any?
            yield path
          end
        end
      end
    end
  end
end
