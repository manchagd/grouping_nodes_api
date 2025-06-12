# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NodeBlueprint do
  let(:node) { create(:node) }

  context 'when no view is specified' do
    subject { NodeBlueprint.render_as_hash(node) }

    it 'serializes the node with default attributes' do
      is_expected.to match({
        id: node.id,
        name: node.name,
        plate: node.plate,
        status: node.status,
        category_id: node.category_id
      })
    end
  end

  context 'when extended view is requested' do
    subject { NodeBlueprint.render_as_hash(node, view: :extended) }

    it 'serializes the node with all the extended attributes' do
      is_expected.to match({
        id: node.id,
        name: node.name,
        plate: node.plate,
        status: node.status,
        category_id: node.category_id,
        category: { id: node.category.id, name: node.category.name },
        description: node.description,
        number: node.number,
        reference_code: node.reference_code,
        relative_age: node.relative_age,
        size: node.size,
        time_slot: node.time_slot,
        created_at: node.created_at
      })
    end
  end
end
