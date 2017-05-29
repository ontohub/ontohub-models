# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    name { generate(:username) } # name is only used for registration
    url_path_method { ->(user) { "/users/#{user.to_param}}" } }
    created_at { Time.current }
    updated_at { Time.current }
    display_name { Faker::Name.name }
    email { Faker::Internet.email(name) }
    password { Faker::Internet.password(10) }
    secret { Faker::Crypto.sha1 }
  end
end
