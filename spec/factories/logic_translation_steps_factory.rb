# frozen_string_literal: true

FactoryBot.define do
  factory :logic_translation_step do
    association :logic_translation

    number { generate(:logic_translation_step_number) }

    trait :with_logic_mapping do
      association :logic_mapping
    end

    trait :with_logic_inclusion do
      association :logic_inclusion
    end
  end
end
