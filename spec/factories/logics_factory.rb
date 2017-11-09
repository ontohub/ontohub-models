# frozen_string_literal: true

FactoryBot.define do
  factory :logic do
    association :language
    name { Faker::Lorem.words(rand(4) + 1).join(' ') }
    slug { "#{name.parameterize}-#{generate(:slug_number)}" }
  end
end
