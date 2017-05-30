# frozen_string_literal: true

FactoryGirl.define do
  factory :organization do
    name { generate(:username) }
    display_name { Faker::Name.name }
    description { Faker::Company.catch_phrase }
    url_path_method { ->(org) { "/organizations/#{org.to_param}}" } }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
