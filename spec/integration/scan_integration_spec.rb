# encoding: utf-8

require 'spec_helper'


describe 'bin/audiothorian scan <PATH>' do
  include_context 'cli setup'

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
      expect { run }.to output(/missing album field/).to_stdout
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
