# frozen_string_literal: true

FactoryGirl.define do
  factory :logic do
    association :language
    name { Faker::Lorem.words(rand(4) + 1).join(' ') }
    slug { name.parameterize }
  end
end
