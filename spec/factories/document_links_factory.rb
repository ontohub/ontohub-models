# frozen_string_literal: true

FactoryGirl.define do
  factory :document_link do
    association :source, factory: :document
    association :target, factory: :document
  end
end
