# encoding: utf-8

require 'thor'


module Audiothority
  class Cli < Thor
    desc 'scan PATHS', 'Scan given paths for inconsistencies'
    method_option :paths_only, type: :boolean, default: false
    def scan(*paths)
      paths = paths.map { |p| Pathname.new(p) }
      crawler = Crawler.new(paths)
      tracker = Tracker.new
      scanner = ScanTask.new(crawler, validations, tracker)
      scanner.run
      summary = (options.paths_only? ? PathsOnlySummary : Summary).new(tracker.state)
      summary.display(console)
    end

    desc 'enforce PATHS', 'Enforce tagging guidelines'
    def enforce(*paths)
      paths = paths.map { |p| Pathname.new(p) }
      crawler = Crawler.new(paths)
      tracker = Tracker.new
      scanner = ScanTask.new(crawler, validations, tracker)
      scanner.run
      summary = Summary.new(tracker.state)
      summary.display(console)
      if tracker.state.any? && should_enforce?
        enforcer = Enforcer.new(tracker.state, FileRefs.new, console)
        enforcer.run
      end
    end

    private

    def should_enforce?
      console.yes?('enforce audiothority on violations?')
    end

    def console
      @console ||= Thor::Shell::Color.new
    end

    def validations
      @validations ||= [ArtistValidator, AlbumValidator, TrackNumberValidator, YearValidator].map(&:new)
    end
  end
end
