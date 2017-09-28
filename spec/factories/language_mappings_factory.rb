# frozen_string_literal: true

FactoryGirl.define do
  factory :language_mapping do
    association :source, factory: :language
    association :target, factory: :language
  end
end
