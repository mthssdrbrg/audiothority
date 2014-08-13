# encoding: utf-8

require 'spec_helper'


module Audiothority
  describe Tracker do
    let :tracker do
      described_class.new
    end

    let :violations do
      [double(:violation)]
    end

    describe '#mark' do
      it 'adds path and violations' do
        tracker.mark('path', violations)
        expect(tracker.suspects).to eq({'path' => violations})
      end
    end

    describe '#suspects' do
      it 'returns marked paths with violations' do
        tracker.mark('path', violations)
        expect(tracker.suspects).to eq({'path' => violations})
      end

      it 'freezes the returned suspects' do
        expect(tracker.suspects).to be_frozen
      end
    end
  end
end
