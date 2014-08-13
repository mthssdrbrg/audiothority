# encoding: utf-8

require 'taglib'


module Audiothority
  class Extract
    def initialize(file_ref=TagLib::FileRef)
      @file_ref = file_ref
    end

    def as_tags(paths, options={})
      file_refs = paths.map { |p| @file_ref.new(p.to_s, false) }
      null_refs = file_refs.select(&:null?)
      if null_refs.any?
        file_refs = file_refs - null_refs
        null_refs.each(&:close)
      end
      if file_refs.empty?
        return
      end
      yield file_refs.map(&:tag)
    ensure
      if file_refs
        file_refs.each(&:save) if options[:save]
        file_refs.each(&:close)
      end
    end
  end
end
