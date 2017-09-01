# frozen_string_literal: true

FactoryGirl.define do
  factory :organization do
    name { generate(:username) }
    display_name { Faker::Name.name }
    description { Faker::Company.catch_phrase }
  end
end
