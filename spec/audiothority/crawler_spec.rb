# encoding: utf-8

require 'spec_helper'


module Audiothority
  describe Crawler do
    let :crawler do
      described_class.new([dir], blacklist)
    end

    let :dir do
      double(:pathname)
    end

    let :blacklist do
      []
    end

    let :child do
      double(:child)
    end

    describe '#crawl' do
      it 'does not yield non-readable paths' do
        non_readable = double(readable?: false)
        allow(dir).to receive(:each_child).and_yield(non_readable)
        expect { |b| crawler.crawl(&b) }.to_not yield_control
      end

      it 'does not yield empty directories' do
        empty_path = double(readable?: true, directory?: true, children: [])
        allow(dir).to receive(:each_child).and_yield(empty_path)
        expect { |b| crawler.crawl(&b) }.to_not yield_control
      end

      it 'does not yield single files' do
        single_file = double(readable?: true, directory?: false)
        allow(dir).to receive(:each_child).and_yield(single_file)
        expect { |b| crawler.crawl(&b) }.to_not yield_control
      end

      it 'yields non-empty directories' do
        valid_dir = double(readable?: true, directory?: true, children: ['non-empty'])
        allow(dir).to receive(:each_child).and_yield(valid_dir)
        expect { |b| crawler.crawl(&b) }.to yield_with_args(valid_dir)
      end

      context 'with blacklist' do
        let :blacklist do
          [/ignore/]
        end

        it 'does not yield paths that match the blacklist' do
          blacklisted_dir = double(readable?: true, directory?: true, children: ['non-empty'], basename: 'ignored')
          allow(dir).to receive(:each_child).and_yield(blacklisted_dir)
          expect { |b| crawler.crawl(&b) }.to_not yield_control
        end
      end
    end
  end
end
