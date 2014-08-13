# encoding: utf-8

module Audiothority
  class Enforcer
    def initialize(suspects, console, options={})
      @suspects = suspects
      @console = console
      @extract = options[:extract] || Extract.new
      @society = options[:society] || EmptySociety.new
    end

    def enforce
      @suspects.each do |path, violations|
        violations = violations.select(&:applicable?)
        @extract.as_tags(path.children, save: true) do |tags|
          changes = violations.map do |violation|
            field = violation.field
            values = fields_from(tags, field)
            choices = choices_from(values)
            Change.new(field, choices, tags)
          end
          changes << RewriteChange.new(:track, tags)
          changes << RewriteChange.new(:year, tags)
          @console.say(%(changes for #{path}:))
          changes.each do |change|
            change.present(@console)
          end
          if perform_changes?
            changes.each(&:perform)
            @society.transfer(path)
            @console.say
          end
        end
      end
    end

    private

    def perform_changes?
      action = @console.ask(perform_question)
      action.empty? || action.downcase == 'p'
    end

    def perform_question
      @perform_question ||= begin
        %([#{@console.set_color('P', :magenta)}]erform or [#{@console.set_color('S', :magenta)}kip]?)
      end
    end

    def fields_from(tags, field)
      tags.map { |t| t.send(field) }
    end

    def choices_from(vs)
      f = vs.each_with_object(Hash.new(0)) { |v, s| s[v] += 1 }
      f = Hash[f.sort_by(&:last)]
      f
    end
  end
end
