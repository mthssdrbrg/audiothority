# encoding: utf-8

require 'spec_helper'


describe 'bin/audiothorian scan <PATH>' do
  include_context 'cli setup'

  context 'when invoked without any paths' do
    let :argv do
      ['scan']
    end

    it 'prints help for the `scan` command' do
      expect { run }.to output(/^Usage:\n.+ scan/).to_stdout
    end
  end

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
      expect { run }.to output(/All is good/).to_stdout
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

    context 'with -C / --custody' do
      let :custody do
        File.join(music_dir, 'custody')
      end

      context ', and custody exists' do
        before do
          Dir.mkdir(custody)
        end

        before do
          run_audiothorian(['scan', music_dir, '-C', custody])
        end

        it 'moves suspects into custody' do
          expect(File.exists?(File.join(music_dir, 'custody', 'the-album'))).to be true
          expect(Dir[%(#{custody}/**/*.mp3)].size).to eq(3)
        end
      end

      context ', and custody does not exist' do
        it 'raises an error' do
          expect { run_audiothorian(['scan', music_dir, '-C', custody]) }.to raise_error(Audiothority::CustodyTorchedError)
        end
      end
    end
  end
end
