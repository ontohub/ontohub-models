# frozen_string_literal: true

FactoryBot.define do
  factory :document_link do
    association :source, factory: :document
    association :target, factory: :document
  end
end
