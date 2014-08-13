# encoding: utf-8

require 'spec_helper'


describe 'bin/audiothorian enforce <PATH>' do
  include_context 'cli setup'

  let :argv do
    ['enforce', music_dir]
  end

  context 'when invoked without any paths' do
    let :argv do
      ['enforce']
    end

    it 'prints help for the `enforce` command' do
      expect { run }.to output(/^Usage:\n.+ enforce/).to_stdout
    end
  end

  it 'presents a list of inconsistent albums' do
    expect do
      interactive(%w[n]) { run }
    end.to output(/the-album is inconsistent due to:/).to_stdout
  end

  context 'when the user answers `y` / `yes` to enforcement' do
    context ', and selects to perform presented changes' do
      it 'corrects inconsistencies' do
        interactive(%w[y P]) do
          expect { run }.to output.to_stdout
        end
        tags_from(%(#{music_dir}/the-album)) do |tags|
          expect(tags.map(&:artist).uniq).to eq(['the artist'])
          expect(tags.map(&:album).uniq).to eq(['the album'])
          expect(tags.map(&:year).uniq).to eq([2001])
        end
      end
    end

    context ', and decides to skip performing changes' do
      it 'does not apply changes' do
        interactive(%w[y S]) do
          expect { run }.to output.to_stdout
        end
        tags_from(%(#{music_dir}/the-album)) do |tags|
          expect(tags.map(&:artist).uniq.size).to be > 1
          expect(tags.map(&:album).uniq.size).to be > 1
          expect(tags.map(&:year).uniq.size).to be > 1
        end
      end
    end
  end

  context 'when the user answer anything else' do
    it 'terminates and does not change any files' do
      interactive(%w[n]) do
        expect { run }.to output.to_stdout
      end
      tags_from(%(#{music_dir}/the-album)) do |tags|
        expect(tags.map(&:artist).uniq.size).to be > 1
        expect(tags.map(&:album).uniq.size).to be > 1
        expect(tags.map(&:year).uniq.size).to be > 1
      end
    end
  end
end
