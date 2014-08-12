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
end
