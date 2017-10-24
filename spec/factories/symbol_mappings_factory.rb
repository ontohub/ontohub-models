# frozen_string_literal: true

FactoryBot.define do
  factory :symbol_mapping do
    association :signature_morphism
    association :source, factory: :symbol
    association :target, factory: :symbol
  end
end
