# encoding: utf-8

module Audiothority
  class Scanner
    def initialize(crawler, file_refs, validations, stats)
      @crawler = crawler
      @file_refs = file_refs
      @validations = validations
      @stats = stats
    end

    def run
      @crawler.each_crawled do |path|
        @file_refs.as_tags(path.children) do |tags|
          violations = @validations.map { |v| v.validate(tags) }.select(&:invalid?)
          if violations.any?
            @stats.mark_invalid(path, violations)
          else
            @stats.mark_valid(path)
          end
        end
      end
    end
  end
end
