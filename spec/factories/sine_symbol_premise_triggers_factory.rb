# frozen_string_literal: true

FactoryGirl.define do
  factory :sine_symbol_premise_trigger do
    association :sine_premise_selection
    association :symbol
    association :premise, factory: :sentence
    min_tolerance { rand }
  end
end
