# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'callbacks' do
    let(:category) { build(:category, name: '  Trimmed Name  ') }

    it 'strips whitespace from name before validation' do
      expect { category.save }.to change(category, :name).from('  Trimmed Name  ').to('Trimmed Name')
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
    describe '.roots' do
      before { create_list(:category, 2, :with_children, children_count: 3) }

      it 'returns categories without a parent' do
        expect(Category.roots.count).to eq(2)
      end

      it 'categories that are returned have null parent_id' do
        expect(Category.roots.pluck(:parent_id).uniq).to eq([ nil ])
      end
    end

    describe '.with_children' do
      before { create_list(:category, 2, :with_children, children_count: 2) }

      it 'returns categories that have at least one child' do
        expect(Category.with_children.count).to eq(2)
      end
    end

    describe '.by_parent_id' do
      let(:parent1) { create(:category) }
      let(:parent2) { create(:category) }

      before do
        create_list(:category, 2, parent: parent1)
        create_list(:category, 3, parent: parent2)
      end

      it "return 3 categories when parent_id is parent2.id" do
        expect(Category.by_parent_id(parent2.id).count).to eq(3)
      end

      it "return 2 categories when parent_id is parent1.id" do
        expect(Category.by_parent_id(parent1.id).count).to eq(2)
      end

      it 'returns categories with expected parent_id' do
        expect(Category.by_parent_id(parent1.id).pluck(:parent_id).uniq).to eq([ parent1.id ])
        expect(Category.by_parent_id(parent2.id).pluck(:parent_id).uniq).to eq([ parent2.id ])
      end
    end
  end

  describe '#descendants' do
    let(:root) { create(:category) }
    let(:child1) { create(:category, parent: root) }
    let(:child2) { create(:category, parent: child1) }
    let!(:child3) { create(:category, parent: child1) }
    let!(:child4) { create(:category, parent: child2) }

    it 'returns all descendants recursively' do
      expect(root.descendants.count).to eq(4)
      expect(child1.descendants.count).to eq(3)
      expect(child2.descendants.count).to eq(1)
    end

    it 'returns the accurate descendants' do
      expect(root.descendants).to match_array([ child1, child2, child3, child4 ])
      expect(child1.descendants).to match_array([ child2, child3, child4 ])
      expect(child2.descendants).to match_array([ child4 ])
    end

    it 'returns empty if it has no childs' do
      expect(child3.descendants).to be_empty
      expect(child4.descendants).to be_empty
    end
  end

  describe '.nested_tree' do
    let(:root) { create(:category, name: 'Root') }
    let!(:child) { create(:category, name: 'Child', parent: root) }

    it 'returns a nested structure of categories' do
      expect(Category.nested_tree).to eq([
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
    let(:children_count) { 3 }
    let(:parent) { create(:category) }
    let!(:category) { create(:category, :with_children, children_count:, parent:) }

    before { category.destroy }

    it 'reassigns children to the parent category after destruction' do
      expect(parent.children.count).to eq(children_count)
    end
  end
end
