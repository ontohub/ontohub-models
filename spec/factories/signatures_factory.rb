# frozen_string_literal: true

FactoryGirl.define do
  factory :signature do
    association :language
    as_json { '{}' }
  end
end
