# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Node, type: :model do
  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:tags) }
  end

  describe 'presence validations' do
    %i[name seal serie status number size time_slot relative_age].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end
  end

  describe 'format validations' do
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

    context 'plate' do
      it { is_expected.to allow_value('ABC123').for(:plate) }
      it { is_expected.not_to allow_value('Ab123').for(:plate) }
      it { is_expected.not_to allow_value('abC123').for(:plate) }
    end
  end

  describe 'numerical validations' do
    it { is_expected.to validate_numericality_of(:status).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(2) }
    it { is_expected.to validate_numericality_of(:time_slot).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(2) }
    it { is_expected.to validate_numericality_of(:relative_age).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(7) }
    it { is_expected.to validate_numericality_of(:number).only_integer }
    it { is_expected.to validate_numericality_of(:size).is_greater_than_or_equal_to(22).is_less_than_or_equal_to(36) }
  end

  describe '#generate_plate' do
    context 'when seal and serie are present' do
      let(:node) { build(:node, seal: 'XYZ', serie: '123') }

      it 'generates the correct plate format' do
        node.generate_plate
        expect(node.plate).to eq('XYZ123')
      end
    end

    context 'when seal or serie is missing' do
      let(:node) { build(:node, seal: nil, serie: '123') }

      it 'does not assign a plate' do
        node.generate_plate
        expect(node.plate).to be_nil
      end
    end
  end

  describe '#assign_reference_code' do
    context 'when reference_code is nil' do
      let(:node) { build(:node, reference_code: nil) }

      it 'assigns a new UUID' do
        node.assign_reference_code
        expect(node.reference_code).to be_present
        expect(node.reference_code).to match(/\A[0-9a-f\-]{36}\z/)
      end
    end
  end

  describe '#set_time_slot_and_age' do
    let(:node1) { build(:node, created_at: Time.zone.local(2025, 5, 16, 10)) }
    let(:node2) { build(:node, created_at: Time.zone.local(2025, 5, 16, 17)) }
    let(:node3) { build(:node, created_at: Time.zone.local(2025, 5, 16, 23)) }

    it 'sets correct time_slot and relative_age based on created_at' do
      node1.set_time_slot_and_age
      expect(node1.time_slot).to eq(TimeSlotEnum::MORNING)
      expect(node1.relative_age).to eq(6)

      node2.set_time_slot_and_age
      expect(node2.time_slot).to eq(TimeSlotEnum::AFTERNOON)
      expect(node2.relative_age).to eq(5)

      node3.set_time_slot_and_age
      expect(node3.time_slot).to eq(TimeSlotEnum::NIGHT)
      expect(node3.relative_age).to eq(3)
    end
  end
end
