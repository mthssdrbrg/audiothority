# encoding: utf-8

module Audiothority
  class Inspector
    def self.scan(dirs, tracker, opts={})
      paths = dirs.map { |d| Pathname.new(d) }
      crawler = Crawler.new(paths)
      validators = opts[:validators] || Validators.default
      inspector = new(crawler, validators, tracker)
      inspector.investigate
    end

    def initialize(crawler, validators, tracker, opts={})
      @crawler = crawler
      @validators = validators
      @tracker = tracker
      @extract = opts[:extract] || Extract.new
    end

    def investigate
      @crawler.crawl do |path|
        @extract.as_tags(path.children) do |tags|
          violations = @validators.map { |v| v.validate(tags) }.select(&:invalid?)
          if violations.any?
            @tracker.mark(path, violations)
          end
        end
      end
    end
  end
end
