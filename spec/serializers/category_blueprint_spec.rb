# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryBlueprint do
  context 'when has no parent' do
    let(:category) { create(:category) }

    context 'and basic view is requested' do
      subject { CategoryBlueprint.render_as_hash(category, view: :basic) }

      it 'only rendes id and name' do
        is_expected.to match({
          :id => category.id,
          :name => category.name
        })
      end
    end

    context 'and extended view is requested' do
      subject { CategoryBlueprint.render_as_hash(category, view: :extended) }

      it 'rendes id, name and parent' do
        is_expected.to match({
          :id => category.id,
          :name => category.name,
          :parent => category.parent
        })
      end
    end

    context 'and no view is specified' do
      subject { CategoryBlueprint.render_as_hash(category) }

      it 'rendes id, name and parent_id' do
        is_expected.to match({
          :id => category.id,
          :name => category.name,
          :parent_id => category.parent_id
        })
      end
    end
  end

  context 'when has a parent' do
    let(:category) { create(:category, :with_parent) }

    context 'and basic view is requested' do
      subject { CategoryBlueprint.render_as_hash(category, view: :basic) }

      it 'only rendes id and name' do
        is_expected.to match({
          :id => category.id,
          :name => category.name
        })
      end
    end

    context 'and extended view is requested' do
      subject { CategoryBlueprint.render_as_hash(category, view: :extended) }

      it 'rendes id, name and parent' do
        is_expected.to match({
          :id => category.id,
          :name => category.name,
          :parent => { :id => category.parent.id, :name => category.parent.name }

        })
      end

      it 'renders parent basic information' do
        expect(subject[:parent]).to match({
          :id => category.parent.id,
          :name => category.parent.name
        })
      end
    end

    context 'and no view is specified' do
      subject { CategoryBlueprint.render_as_hash(category) }

      it 'rendes id, name and parent_id' do
        is_expected.to match({
          :id => category.id,
          :name => category.name,
          :parent_id => category.parent_id
        })
      end
    end
  end
end
