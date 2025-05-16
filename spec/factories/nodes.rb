# frozen_string_literal: true

FactoryBot.define do
  factory :node do
    description { "Sample description for Node." }
    sequence(:name) { |n| "Node #{n}" }
    sequence(:number) { |n| n }
    sequence(:seal) { |n| "XYZ" }
    sequence(:serie) { |n| "#{(100 + n)}" }
    sequence(:size) { |n| (22 + (n % 15)).to_f }
  end
end
