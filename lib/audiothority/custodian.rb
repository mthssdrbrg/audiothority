# encoding: utf-8

require 'fileutils'


module Audiothority
  CustodyTorchedError = Class.new(ArgumentError)

  class Custodian
    def initialize(custody, suspects, fileutils=FileUtils)
      @custody = Pathname.new(custody)
      @suspects = suspects
      @fileutils = fileutils
    end

    def throw_in_custody
      if @custody.exist?
        @suspects.each do |path, _|
          @fileutils.copy_entry(path.to_s, @custody.join(path.basename).to_s, true)
        end
      else
        raise CustodyTorchedError, %("#{@custody}" seems to have been torched)
      end
    end
  end
end
