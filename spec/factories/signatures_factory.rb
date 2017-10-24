# frozen_string_literal: true

FactoryBot.define do
  factory :signature do
    association :language
    as_json { '{}' }
  end
end
