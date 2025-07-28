# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:nodes) }
  end

  describe '#normalize_name' do
    context 'when the model has a name attribute' do
      subject { create(:tag, name: "nAme to Be noRmalizED") }

      it 'returns a normalized name attribute' do
        expect(subject.name).to eq('Name To Be Normalized')
      end
    end
  end
end
