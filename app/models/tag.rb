# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#
class Tag < ApplicationRecord
  has_and_belongs_to_many :nodes

  validates :name, presence: true, uniqueness: true

  def assign_to_nodes(nodes)
    nodes.each { |node| self.nodes << node unless self.nodes.include?(node) }
  end

  def assigned_to_node?(node)
    self.nodes.exists?(node.id)
  end
end
