# frozen_string_literal: true

FactoryGirl.define do
  factory :signature_morphism do
    association :logic_mapping
    association :source, factory: :signature
    association :target, factory: :signature
    as_json { '{}' }
  end
end
