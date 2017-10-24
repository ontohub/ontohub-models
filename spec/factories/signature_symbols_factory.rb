# frozen_string_literal: true

FactoryBot.define do
  factory :signature_symbol do
    association :signature
    association :symbol
    imported { Faker::Boolean.boolean(0.2) }
  end
end
