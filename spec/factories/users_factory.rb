# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    name { generate(:username) }
    url_path { "/users/#{Slug.sluggify(name)}" }
    created_at { Time.current }
    updated_at { Time.current }
    real_name { Faker::Name.name }
    email { Faker::Internet.email(name) }
    password { Faker::Internet.password }
    secret { Faker::Crypto.sha1 }
  end
end
