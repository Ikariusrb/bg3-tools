# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item #{n}" }
    description { "A test item description" }
    item_type { "helmets" }
    rarity { "Common" }
    weight { "1" }
    price { "100" }
  end
end
