# encoding: utf-8

require 'spec_helper'


module Audiothority
  describe ScanTask do
    let :task do
      described_class.new(crawler, [validator], tracker, extract: extract)
    end

    let :crawler do
      double(:crawler)
    end

    let :validator do
      double(:validator)
    end

    let :tracker do
      double(:tracker, mark: nil)
    end

    let :extract do
      double(:extract)
    end

    let :path do
      double(:path, children: children)
    end

    let :children do
      [Pathname.new('file01')]
    end

    let :violation do
      double(:violation, invalid?: true)
    end

    let :tags do
      [double(:tag)]
    end

    before do
      allow(crawler).to receive(:crawl).and_yield(path)
      allow(extract).to receive(:as_tags).with(children).and_yield(tags)
      allow(validator).to receive(:validate).with(tags).and_return(violation)
    end

    before do
      task.run
    end

    describe '#run' do
      it 'crawls for paths with violations' do
        expect(crawler).to have_received(:crawl)
      end

      it 'extracts tags' do
        expect(extract).to have_received(:as_tags).with(children)
      end

      it 'validates each tag set' do
        expect(validator).to have_received(:validate).with(tags)
      end

      it 'tracks paths with violations' do
        expect(tracker).to have_received(:mark).with(path, [violation])
      end
    end
  end
end
