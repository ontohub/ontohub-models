# frozen_string_literal: true

FactoryGirl.define do
  factory :serialization do
    association :language
    name { Faker::Lorem.words(4, true).join(' ') }
    slug { name.parameterize }
  end
end
