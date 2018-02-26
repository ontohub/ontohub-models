# frozen_string_literal: true

FactoryBot.define do
  factory :logic_inclusion do
    association :language, factory: :language
    association :source, factory: :logic
    association :target, factory: :logic

    name { Faker::Lorem.words(4, true).join(' ') }
    slug { "#{name.parameterize}-#{generate(:slug_number)}" }
  end
end
