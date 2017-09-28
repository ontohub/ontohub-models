# frozen_string_literal: true

FactoryGirl.define do
  factory :sine_symbol_commonness do
    association :sine_premise_selection
    association :symbol
    commonness { rand(100) }
  end
end
