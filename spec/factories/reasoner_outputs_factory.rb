# frozen_string_literal: true

FactoryBot.define do
  factory :reasoner_output do
    association :reasoning_attempt
    association :reasoner
    text { Faker::Lorem.sentences(2).join(' ') }
  end
end
