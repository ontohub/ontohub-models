# frozen_string_literal: true

FactoryBot.define do
  factory :logic_translation do
    name { Faker::Lorem.words(4, true).join(' ') }
    slug { "#{name.parameterize}-#{generate(:slug_number)}" }
  end
end
