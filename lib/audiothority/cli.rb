# encoding: utf-8

require 'thor'


module Audiothority
  class Cli < Thor
    desc 'check PATHS', 'Check given paths for inconsistencies'
    def check(*paths)
      paths = paths.map { |p| Pathname.new(p) }
      crawler = Crawler.new(paths)
      file_refs = FileRefs.new
      stats = Stats.new
      summary = Summary.new(stats)
      scanner = Scanner.new(crawler, file_refs, validations, stats)
      scanner.run
      summary.display(console)
    end

    private

    def console
      @console ||= Thor::Shell::Color.new
    end

    def validations
      @validations ||= [ArtistValidator, AlbumValidator, YearValidator].map(&:new)
    end
  end
end
