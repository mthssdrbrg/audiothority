# encoding: utf-8

module Audiothority
  class Change
    def initialize(field, choices, tags)
      @field = field
      @choices = choices
      @tags = tags
    end

    def perform
      if performable?
        @tags.each do |tag|
          tag.send(tag_setter, value)
        end
      end
    end

    def present(display)
      if performable?
        ignored = @choices.reject { |k, _| k == value }
        ignored = ignored.map do |v, c|
          %("#{display.set_color(v, :red)}" (#{c}))
        end
        chosen = %("#{display.set_color(value, :green)}" (#{@choices[value]}))
        table = ignored.map do |i|
          [display.set_color(@field, :yellow), i, '~>', chosen]
        end
        display.print_table(table, indent: 2)
      end
    end

    private

    def tag_setter
      @tag_setter ||= (@field.to_s + '=').to_sym
    end

    def value
      @value ||= @choices.keys.last
    end

    def performable?
      @choices.any? && (@choices.one? || majority?)
    end

    def majority?
      @choices.values[-2..-1].uniq.size == 2
    end
  end

  class RewriteChange < Change
    def initialize(field, tags)
      @field = field
      @tags = tags
    end

    def perform
      @tags.each do |tag|
        tag.send(tag_setter, tag.send(@field))
      end
    end

    def present(display)
      display.say(%(  #{display.set_color(@field, :yellow)} rewrite field))
    end
  end

  class Enforcer
    def initialize(victims, file_refs, console)
      @victims = victims
      @file_refs = file_refs
      @console = console
    end

    def run
      @victims.each do |path, violations|
        violations = violations.select(&:changeable?)
        @file_refs.as_tags(path.children, save: true) do |tags|
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
      f = f.sort_by { |_, v| v }.to_h
      f
    end
  end
end
