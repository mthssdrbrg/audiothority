# encoding: utf-8

require 'spec_helper'


module Audiothority
  describe Custodian do
    let :custodian do
      described_class.new(custody, suspects, fileutils)
    end

    let :custody do
      Dir.mktmpdir
    end

    let :suspects do
      {
        Pathname.new('suspect1') => double(:violations),
        Pathname.new('suspect2') => double(:violations),
      }
    end

    let :fileutils do
      double(:fileutils)
    end

    before do
      allow(fileutils).to receive(:copy_entry)
    end

    after do
      FileUtils.remove_entry_secure(custody) if File.exists?(custody)
    end

    describe '#throw_in_custody' do
      context 'when `custody` exists' do
        before do
          custodian.throw_in_custody
        end

        it 'moves all suspects to custody' do
          expect(fileutils).to have_received(:copy_entry).with('suspect1', %(#{custody}/suspect1), anything)
          expect(fileutils).to have_received(:copy_entry).with('suspect2', %(#{custody}/suspect2), anything)
        end

        it 'peserves attributes' do
          expect(fileutils).to have_received(:copy_entry).with(anything, anything, true).twice
        end
      end

      context 'when `custody does not exist' do
        let :custody do
          'i do not exist, mkay?'
        end

        it 'assumes that the custody has been torched' do
          expect { custodian.throw_in_custody }.to raise_error(CustodyTorchedError, /seems to have been torched/)
        end
      end
    end
  end
end
