# frozen_string_literal: true

FactoryBot.define do
  factory :repository do
    association :owner, factory: :user
    name { generate :repository_name }
    description { Faker::Lorem.sentence }
    public_access { true }
    content_type { %w(ontology specification model mathematical).sample }
  end
end
