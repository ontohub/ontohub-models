# frozen_string_literal: true

FactoryGirl.define do
  factory :repository do
    association :namespace
    name { Faker::Name.last_name }
    description { Faker::Lorem.sentence }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
