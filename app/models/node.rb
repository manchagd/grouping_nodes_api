# == Schema Information
#
# Table name: nodes
#
#  id             :bigint           not null, primary key
#  description    :text
#  name           :string           not null
#  number         :integer          not null
#  plate          :string           not null
#  reference_code :uuid             not null
#  relative_age   :integer          not null
#  seal           :string(3)        not null
#  serie          :string(3)        not null
#  size           :float            not null
#  status         :integer          not null
#  time_slot      :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :bigint           not null
#
# Indexes
#
#  index_nodes_on_category_id     (category_id)
#  index_nodes_on_plate           (plate) UNIQUE
#  index_nodes_on_reference_code  (reference_code) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
class Node < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :tags

  has_enumeration_for :status, with: NodeStatusEnum, create_helpers: true
  has_enumeration_for :time_slot, with: TimeSlotEnum, create_helpers: true
end
