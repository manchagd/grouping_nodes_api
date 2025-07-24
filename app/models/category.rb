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

  before_validation :parent_must_exist, :prevent_self_parent
  validates :name, presence: true, uniqueness: true
  after_validation { normalize_name(self.name) }
  after_initialize :name_must_be_a_string, :parent_id_must_be_an_integer
  before_destroy :reassign_children

  scope :roots, -> { where(parent_id: nil) }
  scope :with_children, -> { joins(:children).distinct }
  scope :by_parent_id, ->(parent_id) { where(parent_id: parent_id) }

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

  def parent_must_exist
    return if parent_id.nil? || Category.where(id: parent_id).exists?

    errors.add(:parent_id, "must exists in categories")
  end

  def parent_id_must_be_an_integer
    return if parent_id.nil? || attributes_before_type_cast["parent_id"].is_a?(Integer)

    errors.add(:parent_id, "must be an integer")
  end

  def name_must_be_a_string
    return if attributes_before_type_cast["name"].is_a?(String)

    errors.add(:name, "must be a string")
  end

  def prevent_self_parent
    return if id.nil? || parent_id != id

    errors.add(:parent_id, "can't be self-parent")
  end

  def reassign_children
    children.update_all(parent_id: self.parent_id)
  end
end
