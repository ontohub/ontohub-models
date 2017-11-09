# frozen_string_literal: true

FactoryBot.define do
  factory :logic_mapping do
    association :language_mapping, factory: :language_mapping
    association :source, factory: :logic
    association :target, factory: :logic

    name { Faker::Lorem.words(4, true).join(' ') }
    slug { "#{name.parameterize}-#{generate(:slug_number)}" }
    is_inclusion { Faker::Boolean.boolean }
    has_model_expansion { Faker::Boolean.boolean }
    is_weakly_amalgamable { Faker::Boolean.boolean }
  end
end
