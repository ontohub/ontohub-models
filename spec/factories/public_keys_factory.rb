# frozen_string_literal: true

FactoryGirl.define do
  factory :public_key do
    association :user, factory: :user
    name { Faker::Cat.name }
    key { Faker::Crypto.sha256 }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
