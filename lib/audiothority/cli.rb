# encoding: utf-8

require 'thor'


module Audiothority
  class Cli < Thor
    desc 'scan PATHS', 'Scan given paths for inconsistencies'
    method_option :paths_only,
      desc: 'only display paths for inconsistent directories',
      type: :boolean,
      default: false
    method_option :custody,
      desc: 'move inconsistent directories to a custody directory',
      aliases: '-C',
      type: :string
    def scan(*paths)
      if paths.any?
        run_scan_for(paths)
        display_summary
        throw_in_custody
      else
        self.class.task_help(console, 'scan')
      end
    end

    desc 'enforce PATHS', 'Enforce tagging guidelines'
    def enforce(*paths)
      if paths.any?
        run_scan_for(paths)
        display_summary
        if tracker.suspects.any? && should_enforce?
          Enforcer.new(tracker.suspects, console).enforce
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

    def tracker
      @tracker ||= Tracker.new
    end

    def run_scan_for(paths)
      Inspector.scan(paths, tracker)
    end

    def display_summary
      s = (options.paths_only? ? PathsOnlySummary : Summary).new(tracker.suspects)
      s.display(console)
    end

    def throw_in_custody
      if options.custody
        c = Custodian.new(options.custody, tracker.suspects)
        c.throw_in_custody
      end
    end
  end
end
