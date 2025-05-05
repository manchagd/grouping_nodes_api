class Tag < ApplicationRecord
  has_many :node_tags
  has_many :nodes, through: :node_tags

  validates :name, presence: true, uniqueness: true

  def assigned?
    nodes.exists?
  end
  
  def assign_to(node)
    nodes << node unless nodes.include?(node)
  end
  
  def remove_from(node)
    nodes.destroy(node)
  end

  scope :unassigned, -> { left_outer_joins(:node_tags).where(node_tags: { id: nil }) }
  scope :assigned, -> { joins(:node_tags).distinct }
  scope :search_by_name, ->(query) {
    where("LOWER(name) LIKE ?", "%#{query.downcase}%")
  }
end
