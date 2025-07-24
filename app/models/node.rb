# frozen_string_literal: true

# == Schema Information
#
# Table name: nodes
#
#  id             :bigint           not null, primary key
#  description    :text
#  name           :string           not null
#  number         :integer
#  plate          :string
#  reference_code :uuid
#  relative_age   :integer
#  seal           :string(3)
#  serie          :string(3)
#  size           :float
#  status         :string
#  time_slot      :string
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
  attr_accessor :code_version, :code_url

  belongs_to :category
  has_and_belongs_to_many :tags

  has_enumeration_for :status, with: NodeStatusEnum, create_helpers: true
  has_enumeration_for :time_slot, with: TimeSlotEnum, create_helpers: true

  validates :name, :seal, :serie, :number, :size, :status, presence: true
  validates :plate, :reference_code, uniqueness: true
  validates :seal,  format: { with: /\A[A-Z]{3}\z/, message: "Only 3 uppercase letters are allowed" }
  validates :serie, format: { with: /\A\d{3}\z/,    message: "Only 3 digits are allowed" }
  validates :plate, format: { with: /\A[A-Z]{3}\d{3}\z/, message: "Invalid plate format" }
  validates :number, numericality: { only_integer: true }
  validates :size, numericality: { greater_than_or_equal_to: 22, less_than_or_equal_to: 36 }
  validate :reference_code_version_and_structure

  before_validation :generate_plate
  after_validation :generate_reference_code, if: ->() { errors.empty? }
  before_validation :normalize_name
  after_create :set_time_slot_and_age

  private

  def generate_plate
    self.plate = "#{seal}#{serie}"
  end

  def generate_reference_code
    self.reference_code =
      case code_version.to_i
      when 1
        UUIDTools::UUID.timestamp_create
      when 3
        UUIDTools::UUID.md5_create(UUIDTools::UUID_DNS_NAMESPACE, code_url)
      when 4
        UUIDTools::UUID.random_create
      when 5
        UUIDTools::UUID.sha1_create(UUIDTools::UUID_DNS_NAMESPACE, code_url)
      else
        reference_code
      end
  end

  def reference_code_version_and_structure
    return if code_version.blank?

    errors.add(:code_version, "must be 1, 3, 4, or 5") unless [ 1, 3, 4, 5 ].include?(code_version.to_i)
    errors.add(:code_url, "must be present for UUID versions 3 and 5") if [ 3, 5 ].include?(code_version.to_i) && code_url.blank?
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

    self.save!
  end
end
