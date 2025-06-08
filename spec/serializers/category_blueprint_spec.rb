# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryBlueprint do
  context 'when has no parent' do
    let(:category) { create(:category) }

    context 'and basic view is requested' do
      subject { JSON.parse(CategoryBlueprint.render(category, view: :basic)) }

      it 'only rendes id and name' do
        is_expected.to match({
          'id' => category.id,
          'name' => category.name
        })
      end

      it 'does not render parent_id' do
        is_expected.not_to have_key('parent_id')
      end
    end

    context 'and extended view is requested' do
      subject { JSON.parse(CategoryBlueprint.render(category, view: :extended)) }

      it 'rendes id, name and parent' do
        is_expected.to match({
          'id' => category.id,
          'name' => category.name,
          'parent' => category.parent
        })
      end

      it 'does not render a parent_id' do
        is_expected.not_to have_key('parent_id')
      end
    end

    context 'and no view is specified' do
      subject { JSON.parse(CategoryBlueprint.render(category)) }

      it 'rendes id, name and parent_id' do
        is_expected.to match({
          'id' => category.id,
          'name' => category.name,
          'parent_id' => category.parent_id
        })
      end

      it 'does not render a parent' do
        is_expected.not_to have_key('parent')
      end
    end
  end

  context 'when has a parent' do
    let(:category) { create(:category, :with_parent) }

    context 'and basic view is requested' do
      subject { JSON.parse(CategoryBlueprint.render(category, view: :basic)) }

      it 'only rendes id and name' do
        is_expected.to match({
          'id' => category.id,
          'name' => category.name
        })
      end

      it 'does not render parent_id' do
        is_expected.not_to have_key('parent_id')
      end
    end

    context 'and extended view is requested' do
      subject { JSON.parse(CategoryBlueprint.render(category, view: :extended)) }

      it 'rendes id, name and parent' do
        is_expected.to match({
          'id' => category.id,
          'name' => category.name,
          'parent' => { 'id' => category.parent.id, 'name' => category.parent.name }

        })
      end

      it 'renders parent basic information' do
        expect(subject['parent']).to match({
          'id' => category.parent.id,
          'name' => category.parent.name
        })
      end

      it 'does not render a parent_id' do
        is_expected.not_to have_key('parent_id')
      end
    end

    context 'and no view is specified' do
      subject { JSON.parse(CategoryBlueprint.render(category)) }

      it 'rendes id, name and parent_id' do
        is_expected.to match({
          'id' => category.id,
          'name' => category.name,
          'parent_id' => category.parent_id
        })
      end

      it 'does not render a parent' do
        is_expected.not_to have_key('parent')
      end
    end
  end
end
