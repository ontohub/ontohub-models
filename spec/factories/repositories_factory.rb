# frozen_string_literal: true

FactoryGirl.define do
  factory :repository do
    association :owner, factory: :user
    name { generate :repository_name }
    description { Faker::Lorem.sentence }
    public_access { false }
    content_type { %w(ontology specification model mathematical).sample }
  end
end
