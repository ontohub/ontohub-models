# frozen_string_literal: true

FactoryGirl.define do
  factory :generated_axiom do
    association :reasoning_attempt
    text { Faker::Lorem.sentence }
  end
end
