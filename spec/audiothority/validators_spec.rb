# encoding: utf-8

require 'spec_helper'


module Audiothority
  module Validators
    shared_examples_for 'an uniqueness validator' do
      let :validator do
        described_class.new
      end

      context 'when `field` is unique among given tags' do
        let :tags do
          3.times.map { |i| OpenStruct.new(field => 'same') }
        end

        it 'returns a `valid` validation' do
          expect(validator.validate(tags)).to be_valid
        end
      end

      context 'when `field` is not unique among given tags' do
        let :tags do
          3.times.map { |i| OpenStruct.new(field => i) }
        end

        it 'returns an `invalid` validation' do
          expect(validator.validate(tags)).to be_invalid
        end

        it 'indicates which field it is concerned about' do
          violation = validator.validate(tags)
          expect(violation.field).to eq(field)
        end

        it 'reports that there are multiple values for field' do
          violation = validator.validate(tags)
          expect(violation.reason).to eq(:multiple)
        end
      end

      context 'when `field` is not present among given tags' do
        let :tags do
          3.times.map { |i| OpenStruct.new(field => nil) }
        end

        it 'returns an `invalid` validation' do
          expect(validator.validate(tags)).to be_invalid
        end

        it 'indicates which field it is concerned about' do
          violation = validator.validate(tags)
          expect(violation.field).to eq(field)
        end

        it 'reports that field is missing' do
          violation = validator.validate(tags)
          expect(violation.reason).to eq(:missing)
        end

        it 'reports an applicable violation' do
          violation = validator.validate(tags)
          expect(violation).to be_applicable
        end
      end
    end

    describe Artist do
      it_behaves_like 'an uniqueness validator' do
        let :field do
          :artist
        end
      end
    end

    describe Album do
      it_behaves_like 'an uniqueness validator' do
        let :field do
          :album
        end
      end
    end

    describe Year do
      it_behaves_like 'an uniqueness validator' do
        let :field do
          :year
        end
      end
    end

    describe TrackNumber do
      let :validator do
        described_class.new
      end

      context 'when `track` is present among all tags' do
        let :tags do
          3.times.map { |i| OpenStruct.new(track: i + 1) }
        end

        it 'returns a `valid` validation' do
          expect(validator.validate(tags)).to be_valid
        end
      end

      context 'when `track` of any tag is zero (0)' do
        let :tags do
          3.times.map { |i| OpenStruct.new(track: i) }
        end

        it 'returns an `invalid` validation' do
          expect(validator.validate(tags)).to be_invalid
        end

        it 'indicates which field it is concerned about' do
          violation = validator.validate(tags)
          expect(violation.field).to eq(:track)
        end

        it 'reports one or more tags are missing track numbers' do
          violation = validator.validate(tags)
          expect(violation.reason).to eq(:missing)
        end

        it 'reports a non-applicable violation' do
          violation = validator.validate(tags)
          expect(violation).to_not be_applicable
        end
      end
    end
  end
end
