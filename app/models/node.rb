# frozen_string_literal: true

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
#  status         :string           not null
#  time_slot      :string           not null
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

  validates :name, :seal, :serie, :status, :number, :size, :uuid, presence: true
  validates :plate, :reference_code, uniqueness: true
  validates :seal,  format: { with: /\A[A-Z]{3}\z/, message: "Only 3 uppercase letters are allowed" }
  validates :serie, format: { with: /\A\d{3}\z/,    message: "Only 3 digits are allowed" }
  validates :plate, format: { with: /\A[A-Z]{3}\d{3}\z/, message: "Invalid plate format" }
  validates :number, numericality: { only_integer: true }
  validates :size, numericality: { greater_than_or_equal_to: 22, less_than_or_equal_to: 36 }
  validate :reference_code_version_and_structure

  before_validation :generate_plate
  after_create :set_time_slot_and_age

  private

  def generate_plate
    self.plate = "#{seal}#{serie}" if seal.present? && serie.present?
  end

  def reference_code_version_and_structure
  end

  def set_time_slot_and_age
    hour = self.created_at.hour

    case hour
    when 4...12
        self.time_slot = TimeSlotEnum::MORNING
        self.relative_age = hour - 4
    when 12...20
        self.time_slot = TimeSlotEnum::AFTERNOON
        self.relative_age = hour - 12
    else
        self.time_slot = TimeSlotEnum::NIGHT
        self.relative_age = hour < 4 ? hour + 4 : hour - 20
    end
  end
end
