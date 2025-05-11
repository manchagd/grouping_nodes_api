# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'callbacks' do
    it 'strips whitespace from name before validation' do
      category = Category.create(name: '  Trimmed Name  ')
      expect(category.name).to eq('Trimmed Name')
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:parent).class_name('Category').optional }
    it { is_expected.to have_many(:children).class_name('Category').with_foreign_key('parent_id') }
  end

  describe 'scopes' do
    let(:root) { create(:category) }
    let(:child1) { create(:category, parent: root) }
    let(:child2) { create(:category, parent: root) }
    let(:other_root) { create(:category) }
    let(:other_child) { create(:category, parent: other_root) }

    describe '.roots' do
      it 'returns categories without a parent' do
        root
        other_root
        child1
        expect(Category.roots).to include(root)
        expect(Category.roots).to include(other_root)
        expect(Category.roots).not_to include(child1)
      end
    end

    describe '.with_children' do
      it 'returns categories that have at least one child' do
        root
        child1
        child2
        other_root
        other_child
        expect(Category.with_children).to include(root)
        expect(Category.with_children).to include(other_root)
        expect(Category.with_children).not_to include(child2)
      end
    end

    describe '.by_parent_id' do
      it 'returns categories that belong to the given parent_id' do
        root
        child1
        child2
        other_root
        other_child
        expect(Category.by_parent_id(root.id)).to match_array([ child1, child2 ])
        expect(Category.by_parent_id(root.id)).not_to include(other_child)
        expect(Category.by_parent_id(other_root.id)).to match_array([ other_child ])
        expect(Category.by_parent_id(other_root.id)).not_to include(child1)
      end
    end
  end

  describe '#descendants' do
    let(:root) { create(:category) }
    let(:child1) { create(:category, parent: root) }
    let(:child2) { create(:category, parent: child1) }

    it 'returns all descendants recursively' do
      root
      child1
      child2
      expect(root.descendants).to match_array([ child1, child2 ])
      expect(child1.descendants).to match_array([ child2 ])
      expect(child2.descendants).to be_empty
    end
  end

  describe '.nested_tree' do
    let(:root) { create(:category, name: 'Root') }
    let(:child) { create(:category, name: 'Child', parent: root) }

    it 'returns a nested structure of categories' do
      root
      child
      tree = Category.nested_tree
      expect(tree).to eq([
        {
          id: root.id,
          name: 'Root',
          children: [
            {
              id: child.id,
              name: 'Child',
              children: []
            }
          ]
        }
      ])
    end
  end

  describe '#reassign_children' do
  let(:grandparent) { create(:category, name: 'Grandparent') }
  let(:parent) { create(:category, name: 'Parent', parent: grandparent) }
  let(:child1) { create(:category, name: 'Child1', parent: parent) }
  let(:child2) { create(:category, name: 'Child2', parent: parent) }

    it 'reassigns children to the parent category after destruction' do
      grandparent
      parent
      child1
      child2
      parent.destroy
      [ child1.reload, child2.reload ].each do |child|
        expect(child.parent).to eq(grandparent)
      end
    end
  end
end
