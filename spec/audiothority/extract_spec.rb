# encoding: utf-8

require 'spec_helper'


module Audiothority
  describe Extract do
    let :extract do
      described_class.new(file_ref)
    end

    let :file_ref do
      double(:file_ref)
    end

    before do
      allow(file_ref).to receive(:new).and_return(*refs)
    end

    describe '#as_tags' do
      context 'when given a proper set of audio files' do
        let :paths do
          [double(:audio_file)]
        end

        let :refs do
          [double(:file_ref, null?: false, tag: tags.first, close: nil)]
        end

        let :tags do
          [double(:tag)]
        end

        it 'yields extracted tags' do
          expect { |b| extract.as_tags(paths, &b) }.to yield_with_args(tags)
        end

        it 'closes file refs' do
          extract.as_tags(paths) { }
          refs.each do |ref|
            expect(ref).to have_received(:close)
          end
        end
      end

      context 'when given a set of files that includes non-audio files' do
        let :paths do
          [double(:audio_file), double(:non_audio_file)]
        end

        let :refs do
          [
            double(:file_ref, null?: false, tag: tags.first, close: nil),
            double(:file_ref, null?: true, close: nil),
          ]
        end

        let :tags do
          [double(:tag)]
        end

        it 'skips `null` tags' do
          expect { |b| extract.as_tags(paths, &b) }.to yield_with_args(tags)
        end

        it 'closes `null` refs' do
          extract.as_tags(paths) { }
          expect(refs.last).to have_received(:close)
        end

        it 'closes file refs' do
          extract.as_tags(paths) { }
          refs.each do |ref|
            expect(ref).to have_received(:close)
          end
        end
      end

      context 'when given a set of non-audio files' do
        let :paths do
          [double(:non_audio_file), double(:non_audio_file)]
        end

        let :refs do
          [
            double(:file_ref, null?: true, close: nil),
            double(:file_ref, null?: true, close: nil),
          ]
        end

        it 'does not yield anything' do
          expect { |b| extract.as_tags(paths, &b) }.to_not yield_control
        end

        it 'closes file refs' do
          extract.as_tags(paths) { }
          refs.each do |ref|
            expect(ref).to have_received(:close)
          end
        end
      end

      context 'when given `:save` => true' do
        let :paths do
          [double(:audio_file)]
        end

        let :refs do
          [double(:file_ref, null?: false, tag: tags.first, close: nil, save: nil)]
        end

        let :tags do
          [double(:tag)]
        end

        it 'saves file refs before closing them' do
          extract.as_tags(paths, save: true) { }
          refs.each do |ref|
            expect(ref).to have_received(:save).ordered
            expect(ref).to have_received(:close).ordered
          end
        end
      end
    end
  end
end
