# frozen_string_literal: true

FactoryBot.define do
  factory :generated_axiom do
    association :reasoning_attempt, factory: :proof_attempt
    text { Faker::Lorem.sentence }
  end
end
