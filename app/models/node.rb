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
require "uuidtools"

class Node < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :tags

  has_enumeration_for :status, with: NodeStatusEnum, create_helpers: true
  has_enumeration_for :time_slot, with: TimeSlotEnum, create_helpers: true

  validates :name, :seal, :serie, :plate, :status, :number, :size, :reference_code, :time_slot, :relative_age, presence: true
  validates :plate, uniqueness: true
  validates :reference_code, uniqueness: true

  validates :seal,  format: { with: /\A[A-Z]{3}\z/, message: "Only 3 uppercase letters are allowed" }
  validates :serie, format: { with: /\A\d{3}\z/,    message: "Only 3 digits are allowed" }
  validates :plate, format: { with: /\A[A-Z]{3}\d{3}\z/, message: "Invalid plate format" }

  validates :status, :time_slot, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2 }
  validates :relative_age, numericality: {  only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 7 }
  validates :number, numericality: { only_integer: true }
  validates :size, numericality: { greater_than_or_equal_to: 22, less_than_or_equal_to: 36 }

  before_validation :generate_plate, :assign_reference_code, :set_time_slot_and_age

  def generate_plate
    self.plate = "#{seal}#{serie}" if seal.present? && serie.present?
  end

  def assign_reference_code
    self.reference_code ||= UUIDTools::UUID.random_create.to_s
  end

  def set_time_slot_and_age
    return unless created_at.present?
    hour = created_at.hour

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
