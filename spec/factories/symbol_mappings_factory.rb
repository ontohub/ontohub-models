# frozen_string_literal: true

FactoryGirl.define do
  factory :symbol_mapping do
    association :signature_morphism
    association :source, factory: :symbol
    association :target, factory: :symbol
  end
end
