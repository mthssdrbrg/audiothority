# encoding: utf-8

require 'thor'


module Audiothority
  class Cli < Thor
    desc 'scan PATHS', 'Scan given paths for inconsistencies'
    method_option :paths_only, type: :boolean, default: false
    def scan(*paths)
      if paths.any?
        run_scan_for(paths)
        display_summary
      else
        self.class.task_help(console, 'scan')
      end
    end

    desc 'enforce PATHS', 'Enforce tagging guidelines'
    def enforce(*paths)
      if paths.any?
        run_scan_for(paths)
        display_summary
        if tracker.state.any? && should_enforce?
          Enforcer.new(tracker.state, console).enforce
        end
      else
        self.class.task_help(console, 'enforce')
      end
    end

    private

    def should_enforce?
      console.yes?('enforce audiothority on violations?')
    end

    def console
      @console ||= Thor::Shell::Color.new
    end

    def run_scan_for(paths)
      ScanTask.scan(paths, tracker)
    end

    def tracker
      @tracker ||= Tracker.new
    end

    def display_summary
      s = (options.paths_only? ? PathsOnlySummary : Summary).new(tracker.state)
      s.display(console)
    end
  end
end
