# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    parent { nil }

    trait :with_parent do
      association :parent, factory: :category
    end

    trait :with_children do
      transient do
        children_count { 5 }
      end

      after(:create) do |category, evaluator|
        create_list(:category, evaluator.children_count, parent: category)
      end
    end
  end
end
