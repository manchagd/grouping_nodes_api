# frozen_string_literal: true

FactoryBot.define do
  factory :node do
    category
    description { "Sample description for Node." }
    sequence(:name) { |n| "Node #{n}" }
    sequence(:number) { |n| n }
    sequence(:seal) { |n| "XYZ" }
    sequence(:serie) { |n| "#{(100 + n)}" }
    sequence(:size) { |n| (22 + (n % 15)).to_f }

    transient do
      code_version { 4 }
      code_url { nil }
    end

    after(:build) do |node, evaluator|
      node.code_version = evaluator.code_version
      node.code_url = evaluator.code_url
    end
  end
end
