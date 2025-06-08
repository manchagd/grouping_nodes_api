# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryBlueprint do
  context 'when has no parent' do
    let(:category) { create(:category) }

    context 'and basic view is requested' do
      let(:basic_view) { JSON.parse(CategoryBlueprint.render(category, view: :basic)) }

      it 'only rendes id and name' do
        expect(basic_view['name']).to be_present
        expect(basic_view['id']).to be_present
      end

      it 'does not render parent_id' do
        expect(basic_view).not_to have_key('parent_id')
      end
    end

    context 'and extended view is requested' do
      let(:extended_view) { JSON.parse(CategoryBlueprint.render(category, view: :extended)) }

      it 'rendes id, name and parent' do
        expect(extended_view['name']).to be_present
        expect(extended_view['id']).to be_present
        expect(extended_view['parent']).to be_nil
      end

      it 'does not render a parent_id' do
        expect(extended_view).not_to have_key('parent_id')
      end
    end

    context 'and no view is specified' do
      let(:no_specific_view) { JSON.parse(CategoryBlueprint.render(category)) }

      it 'rendes id, name and parent_id' do
        expect(no_specific_view['name']).to be_present
        expect(no_specific_view['id']).to be_present
        expect(no_specific_view['parent_id']).to be_nil
      end

      it 'does not render a parent' do
        expect(no_specific_view).not_to have_key('parent')
      end
    end
  end

  context 'when has a parent' do
    let(:category) { create(:category, :with_parent) }

    context 'and basic view is requested' do
      let(:basic_view) { JSON.parse(CategoryBlueprint.render(category, view: :basic)) }

      it 'only rendes id and name' do
        expect(basic_view['name']).to be_present
        expect(basic_view['id']).to be_present
      end

      it 'does not render parent_id' do
        expect(basic_view).not_to have_key('parent_id')
      end
    end

    context 'and extended view is requested' do
      let(:extended_view) { JSON.parse(CategoryBlueprint.render(category, view: :extended)) }

      it 'rendes id, name and parent' do
        expect(extended_view['name']).to be_present
        expect(extended_view['id']).to be_present
        expect(extended_view['parent']).to be_present
      end

      it 'renders parent basic information' do
        expect(extended_view['parent']['id']).to be_present
        expect(extended_view['parent']['id']).to be_present
        expect(extended_view['parent']).not_to have_key('parent_id')
      end

      it 'does not render a parent_id' do
        expect(extended_view).not_to have_key('parent_id')
      end
    end

    context 'and no view is specified' do
      let(:no_specific_view) { JSON.parse(CategoryBlueprint.render(category)) }

      it 'rendes id, name and parent_id' do
        expect(no_specific_view['name']).to be_present
        expect(no_specific_view['id']).to be_present
        expect(no_specific_view['parent_id']).to be_present
      end

      it 'does not render a parent' do
        expect(no_specific_view).not_to have_key('parent')
      end
    end
  end
end
