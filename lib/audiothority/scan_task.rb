# encoding: utf-8

module Audiothority
  class ScanTask
    def self.scan(dirs, tracker, opts={})
      paths = dirs.map { |d| Pathname.new(d) }
      crawler = Crawler.new(paths)
      validators = opts[:validators] || Validators.default
      task = new(crawler, validators, tracker)
      task.run
    end

    def initialize(crawler, validators, tracker, opts={})
      @crawler = crawler
      @validators = validators
      @tracker = tracker
      @extracter = opts[:extracter] || FileRefs.new
    end

    def run
      @crawler.crawl do |path|
        @extracter.as_tags(path.children) do |tags|
          violations = @validators.map { |v| v.validate(tags) }.select(&:invalid?)
          if violations.any?
            @tracker.mark(path, violations)
          end
        end
      end
    end
  end
end
