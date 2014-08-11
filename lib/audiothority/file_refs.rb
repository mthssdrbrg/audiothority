# encoding: utf-8

require 'taglib'


module Audiothority
  class FileRefs
    def as_tags(paths)
      file_refs = paths.map { |p| TagLib::FileRef.new(p.to_s, false) }
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
      file_refs.each(&:close) if file_refs
    end
  end
end
