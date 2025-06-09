# frozen_string_literal: true

FactoryBot.define do
  factory :build do
    sequence(:name) { |n| "Build #{n}" }
    description { "A test build description" }
  end
end
