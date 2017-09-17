# frozen_string_literal: true

FactoryGirl.define do
  factory :reasoner_configuration do
    association :configured_reasoner, factory: :reasoner
    time_limit { rand(60) }
  end
end
