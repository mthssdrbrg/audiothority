# encoding: utf-8

require 'spec_helper'


module Audiothority
  describe Society do
    let :society do
      described_class.new(location, fileutils)
    end

    let :location do
      'society'
    end

    let :fileutils do
      double(:fileutils, move: 0)
    end

    describe '#transfer' do
      it 'moves the enforced entity to society location' do
        society.transfer('enforced')
        expect(fileutils).to have_received(:move).with('enforced', Pathname.new('society'))
      end
    end
  end
end
