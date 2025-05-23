# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#
# Indexes
#
#  index_categories_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => categories.id)
#
class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: "parent_id"
  before_validation :strip_name_whitespace
  before_destroy :reassign_children

  scope :roots, -> { where(parent_id: nil) }
  scope :with_children, -> { joins(:children).distinct }
  scope :by_parent_id, ->(parent_id) { where(parent_id: parent_id) }

  validates :name, presence: true

  def descendants
    children.includes(:children).flat_map do |child|
      [ child ] + child.descendants
    end
  end

  def self.nested_tree(categories = roots)
    categories.map do |category|
      {
        id: category.id,
        name: category.name,
        children: nested_tree(category.children)
      }
    end
  end

  private

  def strip_name_whitespace
    self.name = name.strip if name.present?
  end

  def reassign_children
    children.update_all(parent_id: self.parent_id)
  end
end
