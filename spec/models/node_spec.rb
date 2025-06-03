# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Node, type: :model do
  describe 'associations' do
    subject { build(:node) }

    it { is_expected.to have_and_belong_to_many(:tags) }
    it { is_expected.to belong_to(:category) }
  end

  describe 'presence validations' do
    subject { build(:node) }

    %i[name seal serie number size].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end
  end

  describe 'format validations' do
    subject { build(:node) }

    context 'seal' do
      it { is_expected.to allow_value('ABC').for(:seal) }
      it { is_expected.not_to allow_value('aBC').for(:seal) }
      it { is_expected.not_to allow_value('').for(:seal) }
    end

    context 'serie' do
      it { is_expected.to allow_value('123').for(:serie) }
      it { is_expected.not_to allow_value('12c').for(:serie) }
      it { is_expected.not_to allow_value('').for(:serie) }
    end
  end

  describe 'numerical validations' do
    subject { build(:node) }

    it { is_expected.to validate_numericality_of(:number).only_integer }
    it { is_expected.to validate_numericality_of(:size).is_greater_than_or_equal_to(22).is_less_than_or_equal_to(36) }
  end

  describe 'custom validation: reference_code_version_and_structure' do
    let(:code_version) { 4 }
    let(:code_url) { nil }
    subject { build(:node, code_version:, code_url:) }
    before { subject.save }

    context 'when code_version is invalid' do
      let(:code_version) { 7 }

      it 'adds an error to code_version' do
        expect(subject.errors[:code_version]).to include("must be 1, 3, 4, or 5")
      end
    end

    context 'when code_version is 3 or 5' do
      let(:code_version) { [ 3, 5 ].sample }

      context 'and code_url is missing' do
        it 'adds an error to code_url' do
          expect(subject.errors[:code_url]).to include("must be present for UUID versions 3 and 5")
        end
      end

      context 'and all values are valid' do
        let(:code_url) { "www.example.com" }

        it 'returns true' do
          is_expected.to be_valid
        end
      end
    end
  end

  describe '#generate_plate' do
    let(:seal) { 'XYZ' }
    let(:serie) { '123' }
    subject { build(:node, seal:, serie:) }
    before { subject.save }

    context 'when seal and serie are present' do
      it 'generates the correct plate format' do
        expect(subject.plate).to eq('XYZ123')
      end
    end

    context 'when seal or serie are missing' do
      let(:seal) { nil }

      it 'generates an invalid plate' do
        expect(subject.plate).not_to match(/\A[A-Z]{3}\d{3}\z/)
      end
    end

    context 'when seal or serie are invalid' do
      let(:serie) { '45f' }

      it 'generates an invalid plate' do
        expect(subject.plate).not_to match(/\A[A-Z]{3}\d{3}\z/)
      end
    end
  end

  describe '#generate_reference_code' do
    let(:code_version) { 1 }
    let(:code_url) { nil }
    subject { build(:node, code_version:, code_url:) }
    before { subject.save }

    context 'when code_version is present and code_url is not required' do
      it 'generates a valid UUID' do
        expect(subject.reference_code).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[1345][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i)
      end
    end

    context 'when code_version is 3 or 5' do
      let(:code_version) { [ 3, 5 ].sample }

      context 'and code_url is present' do
        let(:code_url) { "www.example.com" }

        it 'generates a valid UUID' do
          expect(subject.reference_code).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[35][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i)
        end
      end

      context 'and code_url is missing' do
        it 'does not generate UUID' do
          expect(subject.reference_code).to be_nil
        end
      end
    end

    context 'when code_version is invalid' do
      let(:code_version) { 2 }

      it 'does not generate UUID' do
        expect(subject.reference_code).to be_nil
      end
    end
  end

  describe '#set_time_slot_and_age' do
    let(:created_at) { Time.zone.local(2025, 5, 16, 10) }
    subject { create(:node, created_at:) }

    it 'sets correct relative_age based on created_at' do
        expect(subject.relative_age).to eq(6)
    end

    context 'when created_at is between 4 and 12' do
      it 'sets time_slot to MORNING' do
        expect(subject.time_slot).to eq(TimeSlotEnum::MORNING)
      end
    end

    context 'when created_at is between 12 and 20' do
      let(:created_at) { Time.zone.local(2025, 5, 16, 17) }

      it 'sets time_slot to AFTERNOON' do
        expect(subject.time_slot).to eq(TimeSlotEnum::AFTERNOON)
      end
    end

    context 'when created_at is between 20 and 4' do
      let(:created_at) { Time.zone.local(2025, 5, 16, 23) }

      it 'sets time_slot to NIGHT' do
        expect(subject.time_slot).to eq(TimeSlotEnum::NIGHT)
      end
    end
  end
end
