# frozen_string_literal: true

FactoryGirl.define do
  factory :repository do
    association :namespace
    name { generate :repository_name }
    description { Faker::Lorem.sentence }
    created_at { Time.current }
    updated_at { Time.current }
    private_access { false }
    content_type { 'ontology' }
  end
end
