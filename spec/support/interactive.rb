# encoding: utf-8

require 'tempfile'


module InteractiveSupport
  def interactive(input, &block)
    actual_stdin = $stdin
    new_stdin = Tempfile.new('audiothority-stdin')
    new_stdin.puts(input.shift) until input.empty?
    new_stdin.rewind
    $stdin.reopen(new_stdin)
    block.call
  ensure
    $stdin.reopen(actual_stdin)
    new_stdin.close
    new_stdin.unlink
  end

  def tags_from(dir)
    file_refs = Dir[%(#{dir}/*)].map { |p| TagLib::FileRef.new(p) }
    yield file_refs.map(&:tag)
  ensure
    file_refs.each(&:close) if file_refs
  end
end

RSpec.configure do |config|
  config.include(InteractiveSupport)
end
