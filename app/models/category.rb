# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: "parent_id"
  before_validation :strip_name_whitespace
  before_destroy :reassign_children

  validates :name, presence: true

  def descendants
    children.includes(:children).flat_map do |child|
      [ child ] + child.descendants
    end
  end

  def ancestors
    parent ? parent.ancestors + [ parent ] : []
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

  scope :roots, -> { where(parent_id: nil) }
  scope :with_children, -> { joins(:children).distinct }
  scope :leaves, -> { includes(:children).where(children: { id: nil }) }
  scope :by_parent, ->(parent_id) { where(parent_id: parent_id) }

  private

  def strip_name_whitespace
    self.name = name.strip if name.present?
  end

  def reassign_children
    children.each { |child| child.update(parent: self.parent) }
  end
end
