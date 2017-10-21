# frozen_string_literal: true

FactoryBot.define do
  factory :serialization do
    association :language
    name { Faker::Lorem.words(4, true).join(' ') }
    slug { name.parameterize }
  end
end
