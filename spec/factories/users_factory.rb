# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    name { generate(:username) } # name is only used for registration
    display_name { Faker::Name.name }
    email { Faker::Internet.email(name) }
    password { Faker::Internet.password(10) }
    secret { Faker::Crypto.sha1 }
    role { 'user' }

    trait :admin do
      role { 'admin' }
    end
  end
end
