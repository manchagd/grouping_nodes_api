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
    context 'when code_version is invalid' do
      let(:node) { build(:node, code_version: 7) }

      it 'adds an error to code_version' do
        node.valid?
        expect(node.errors[:code_version]).to include("must be 1, 3, 4, or 5")
      end
    end

    context 'when code_version is 3 or 5 and code_url is missing' do
      let(:node) { build(:node, code_version: 5) }

      it 'adds an error to code_url' do
        node.valid?
        expect(node.errors[:code_url]).to include("must be present for UUID versions 3 and 5")
      end
    end

    context 'when all values are valid' do
      let(:node) { build(:node, code_version: 3, code_url: "www.example.com") }

      it 'is valid' do
        expect(node).to be_valid
      end
    end
  end

  describe '#generate_plate' do
    context 'when seal and serie are present' do
      let(:node) { build(:node, seal: 'XYZ', serie: '123') }

      it 'generates the correct plate format' do
        node.valid?
        expect(node.plate).to eq('XYZ123')
      end
    end

    context 'when seal or serie is missing' do
      let(:node) { build(:node, seal: nil, serie: '123') }

      it 'does not assign a plate' do
        node.valid?
        expect(node.plate).not_to match(/\A[A-Z]{3}\d{3}\z/)
      end
    end
  end

  describe '#generate_reference_code' do
    context 'when required attributes are present' do
      let(:node1) { build(:node, code_version: 1) }
      let(:node2) { build(:node, code_version: 3, code_url: "www.example.com") }

      it 'generates a valid UUID' do
        node1.valid?
        node2.valid?
        expect(node1.reference_code).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[1345][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i)
        expect(node2.reference_code).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[1345][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i)
      end
    end

    context 'when attributes are missing or invalid' do
      let(:node1) { build(:node, code_version: 2) }
      let(:node2) { build(:node, code_version: 3) }

      it 'does not generate UUID' do
        node1.valid?
        node2.valid?

        expect(node1.reference_code).to be_nil
        expect(node2.reference_code).to be_nil
      end
    end
  end

  describe '#set_time_slot_and_age' do
    let(:node1) { create(:node, created_at: Time.zone.local(2025, 5, 16, 10)) }
    let(:node2) { create(:node, created_at: Time.zone.local(2025, 5, 16, 17)) }
    let(:node3) { create(:node, created_at: Time.zone.local(2025, 5, 16, 23)) }

    it 'sets correct time_slot and relative_age based on created_at' do
      expect(node1.time_slot).to eq(TimeSlotEnum::MORNING)
      expect(node1.relative_age).to eq(6)

      expect(node2.time_slot).to eq(TimeSlotEnum::AFTERNOON)
      expect(node2.relative_age).to eq(5)

      expect(node3.time_slot).to eq(TimeSlotEnum::NIGHT)
      expect(node3.relative_age).to eq(3)
    end
  end
end
