# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    parent { nil }

    trait :with_parent do
      association :parent, factory: :category
    end
  end
end
