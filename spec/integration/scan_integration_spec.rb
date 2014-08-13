# encoding: utf-8

require 'spec_helper'


describe 'bin/audiothorian scan <PATH>' do
  include_context 'cli setup'

  context 'when a directory does not contain inconsistencies' do
    let :argv do
      ['scan', empty_dir]
    end

    let :empty_dir do
      path = File.join(music_dir, 'empty-dir')
      Dir.mkdir(path)
      path
    end

    it 'prints an `all is good` message' do
      expect { run }.to_not raise_error # output(/All is good/).to_stdout
    end
  end

  context 'when a directory contains directories with inconsistencies' do
    context 'without any options' do
      let :argv do
        ['scan', music_dir]
      end

      it 'scans a given directory and reports inconsistencies' do
        expect { run }.to output(/the-album is inconsistent due to:/).to_stdout
      end

      it 'reports inconsistencies in `artist` field' do
        expect { run }.to output(/multiple artists:/).to_stdout
      end

      it 'reports inconsistencies in `album` field' do
        expect { run }.to output(/multiple albums:/).to_stdout
      end

      it 'reports inconsistencies in `year` field' do
        expect { run }.to output(/multiple years:/).to_stdout
      end
    end

    context 'with --paths-only' do
      let :argv do
        ['scan', music_dir, '--paths-only']
      end

      it 'prints paths to inconsistent albums' do
        expect { run }.to output(/\/the-album$/).to_stdout
      end
    end
  end
end
